import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_topics_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_users_request.dart';
import '../../domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImplements implements NotificationsRepository {
  final NotificationsRemoteDatasource _remoteDatasource;

  NotificationsRepositoryImplements( this._remoteDatasource);
  @override
  Future<Either<Failure, Unit>> initializeLocalNotification() async {
    try {
      final response = await _remoteDatasource.initializeLocalNotification();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeFirebaseNotification() async {
    try {
      final response = await _remoteDatasource.initializeFirebaseNotification();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelNotification({required int id}) async {
    try {
      final response = await _remoteDatasource.cancelNotification(id);
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> createNotificationsChannel({required AndroidNotificationChannel channel}) async {
    try {
      final response = await _remoteDatasource.createNotificationsChannel(channel);
      debugPrint("createNotificationsChannel : $response");

      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> displayFirebaseNotification({required RemoteMessage message}) async {
    try {
      final response1 = await _remoteDatasource.displayFirebaseNotification(message);
      return right(response1);
    } on Exception catch (e) {
      debugPrint("debugging error ${e.toString()}");
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> displayNotification({
    required AppNotification notification,
    bool oneTimeNotification = true,
    NotificationDetails? details,
  }) async {
    try {
      final response = await _remoteDatasource.displayLocalNotification(
        notification: notification,
        oneTimeNotification: oneTimeNotification,
        details: details,
      );
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final response = await _remoteDatasource.getNotifications();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }





  @override
  Future<Either<Failure, Unit>> subscribeToTopic({required String topic}) async {
    try {
      await _remoteDatasource.subscribeToTopic(topic);
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDeviceToken() async {
    try {
      await _remoteDatasource.deleteDeviceToken();
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> unsubscribeToTopic({required String topic}) async {
    try {
      await _remoteDatasource.unsubscribeToTopic(topic);
      return right(unit);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getDeviceToken() async {
    try {
      final response = await _remoteDatasource.getDeviceToken();
      return right(response);
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, String>> refreshDeviceToken() async {
    await FirebaseMessaging.instance.deleteToken();
    return getDeviceToken();
  }

  @override
  Future<Either<Failure, Unit>> registerDeviceToken({
    required String deviceToken,
    required String platform,
  }) async {
    try {
      final response = await _remoteDatasource.registerDeviceToken(
        deviceToken: deviceToken,
        platform: platform,
      );
      debugPrint("Success");
      return right(response);
    } on ServerException {
      return left(ServerFailure());
    } on Exception {
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotificationToTopics({required SendNotificationToTopicsRequest sendNotificationRequest}) async {
    try {
      final response = await _remoteDatasource.sendNotificationToTopics(sendNotificationRequest: sendNotificationRequest);
      return right(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> sendNotificationToUsers({
    required SendNotificationToUsersRequest sendNotificationRequest,
  }) async {
    try {
      final response = await _remoteDatasource.sendNotificationToUsers(sendNotificationRequest: sendNotificationRequest);
      return right(response);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(AnonFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadNotificationImage({required File imageFile}) async {
    try {
      final String imageUrl = await _remoteDatasource.uploadNotificationImage(imageFile);
      return right(imageUrl);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return left(AnonFailure());
    }
  }
}
