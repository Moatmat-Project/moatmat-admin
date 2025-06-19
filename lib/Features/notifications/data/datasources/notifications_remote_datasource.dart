import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_topics_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_users_request.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moatmat_admin/Features/notifications/data/models/device_token_model.dart';
import 'package:moatmat_admin/Features/notifications/data/settings/app_local_notifications_settings.dart';
import 'package:moatmat_admin/Features/notifications/data/settings/firebase_messaging_settings.dart';
import 'package:moatmat_admin/features/notifications/data/handlers/firebase_messaging_handlers.dart';

import '../../domain/entities/app_notification.dart';

abstract class NotificationsRemoteDatasource {
  Future<Unit> initializeLocalNotification();
  Future<Unit> initializeFirebaseNotification();
  Future<Unit> cancelNotification(int id);
  Future<Unit> createNotificationsChannel(AndroidNotificationChannel channel);
  Future<Unit> displayFirebaseNotification(RemoteMessage message);
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  });
  Future<Unit> subscribeToTopic(String topic);
  Future<Unit> unsubscribeToTopic(String topic);
  Future<String> getDeviceToken();
  Future<Unit> deleteDeviceToken();
  Future<Unit> registerDeviceToken({required String deviceToken, required String platform});

  /// Sends a notification to a list of topics.
  Future<Unit> sendNotificationToTopics({
    required SendNotificationToTopicsRequest sendNotificationRequest,
  });

  /// Sends a notification to a list of user IDs.
  Future<Unit> sendNotificationToUsers({
    required SendNotificationToUsersRequest sendNotificationRequest,
  });

  Future<String> uploadNotificationImage(File imageFile);
  Future<List<AppNotification>> getNotifications();
}

class NotificationsRemoteDatasourceImpl implements NotificationsRemoteDatasource {
  final _supabase = Supabase.instance.client;
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<Unit> initializeLocalNotification() async {
    await _requestNotificationPermission();

    for (var channel in AppLocalNotificationsSettings.channels) {
      await createNotificationsChannel(channel);
    }

    await _localNotificationsPlugin.initialize(
      AppLocalNotificationsSettings.settings,
      onDidReceiveNotificationResponse: (response) {},
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );

    return unit;
  }

  @override
  Future<Unit> initializeFirebaseNotification() async {
    await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: AppRemoteNotificationsSettings.showAlert,
      badge: AppRemoteNotificationsSettings.showBadge,
      sound: AppRemoteNotificationsSettings.showSound,
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(onData, onDone: onDone, onError: onError);
    FirebaseMessaging.instance.onTokenRefresh.listen(onTokenRefreshed);

    for (var topic in AppRemoteNotificationsSettings.defaultTopicList) {
      await subscribeToTopic(topic);
    }

    debugPrint("Firebase token: ${await getDeviceToken()}");
    return unit;
  }

  @override
  Future<Unit> createNotificationsChannel(AndroidNotificationChannel channel) async {
    final androidImplementation = _localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.createNotificationChannel(channel);
    return unit;
  }

  @override
  Future<Unit> cancelNotification(int id) async {
    await _localNotificationsPlugin.cancel(id);
    return unit;
  }

  @override
  Future<Unit> displayLocalNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    if (!notification.isValid()) return unit;

    await _localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.subtitle,
      details ?? AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> displayFirebaseNotification(RemoteMessage message) async {
    final notification = AppNotification.fromRemoteMessage(message);
    debugPrint(notification.toString());

    if (message.notification?.title != null || !notification.isValid()) {
      return unit;
    }

    await _localNotificationsPlugin.show(
      DateTime.now().millisecond,
      notification.title,
      notification.subtitle,
      AppLocalNotificationsSettings.defaultNotificationsDetails(),
    );

    return unit;
  }

  @override
  Future<Unit> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    return unit;
  }

  @override
  Future<Unit> unsubscribeToTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    return unit;
  }

  @override
  Future<Unit> deleteDeviceToken() async {
    await _firebaseMessaging.deleteToken();
    return unit;
  }

  @override
  Future<String> getDeviceToken() async {
    final token = Platform.isIOS ? await _firebaseMessaging.getAPNSToken() : await _firebaseMessaging.getToken();

    if (token == null) throw Exception("FCM token is null");
    return token;
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Future<Unit> registerDeviceToken({required String deviceToken, required String platform}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint('User is null');
      throw ServerException();
    }

    final model = DeviceTokenModel.create(
      userId: user.id,
      deviceToken: deviceToken,
      platform: platform,
    );

    try {
      await _supabase.from('device_tokens').delete().eq('user_id', model.userId).eq('platform', model.platform);

      await _supabase.from('device_tokens').insert(model.toMap());
      debugPrint("✅ Device token registered successfully to Supabase");
      return unit;
    } on PostgrestException catch (e) {
      debugPrint('Supabase error: ${e.message}');
      throw ServerException();
    } catch (e) {
      debugPrint('Unexpected error: ${e.toString()}');
      throw ServerException();
    }
  }

  @override
  Future<Unit> sendNotificationToTopics({
    required SendNotificationToTopicsRequest sendNotificationRequest,
  }) async {
    return _invokeNotificationFunction(
      functionName: 'send-notifications-to-topics',
      body: {
        'topics': sendNotificationRequest.topics,
        'notification': sendNotificationRequest.notification.toJson(),
      },
      errorContext: 'send notification to topics',
    );
  }

  @override
  Future<Unit> sendNotificationToUsers({
    required SendNotificationToUsersRequest sendNotificationRequest,
  }) async {
    return _invokeNotificationFunction(
      functionName: 'send-fcm-notifications',
      body: {
        'userIds': sendNotificationRequest.userIds,
        'notification': sendNotificationRequest.notification.toJson(),
      },
      errorContext: 'send notification to users',
    );
  }

  Future<Unit> _invokeNotificationFunction({
    required String functionName,
    required Map<String, dynamic> body,
    required String errorContext,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        functionName,
        body: body,
      );

      if (response.status != 200) {
        final data = response.data as Map<String, dynamic>?;
        final errorMessage = data?['error']?['message'] ?? data?['message'] ?? 'Unknown error from function';
        debugPrint('[$functionName] Failed: $errorMessage');
        throw Exception('Failed to $errorContext: $errorMessage');
      }

      debugPrint('[$functionName] Success: ${response.data}');
      return unit;
    } on FunctionException catch (e) {
      debugPrint('[$functionName] FunctionException: ${e.toString()}');
      debugPrint('Details: ${e.details}');
      throw Exception('Failed to $errorContext: ${e.toString()}');
    } catch (e) {
      debugPrint('[$functionName] Unexpected error: $e');
      throw Exception('Unexpected error while trying to $errorContext.');
    }
  }

  @override
  Future<String> uploadNotificationImage(File imageFile) async {
    try {
      final supabaseStorage = _supabase.storage.from('notifications');
      final file = File(imageFile.path);
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      final path = 'uploads/$fileName';

      await supabaseStorage.upload(
        path,
        file,
        fileOptions: const FileOptions(
          upsert: true,
          contentType: 'image/*',
        ),
      );

      final publicUrl = supabaseStorage.getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      debugPrint('[uploadImage] Upload failed: $e');
      throw Exception('Image upload failed: $e');
    }
  }

  @override
  Future<List<AppNotification>> getNotifications() {
    // TODO: implement getNotifications
    throw UnimplementedError();
  }
}
