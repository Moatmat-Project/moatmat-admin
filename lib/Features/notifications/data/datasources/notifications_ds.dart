import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/notifications/data/models/notification_m.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/notification.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class NotificationDS {
  //
  Future<Unit> sendNotification({
    required String userId,
    required NotificationData notification,
  });
  //
  Future<Unit> sendBulkNotification({
    required List<String> userIds,
    required NotificationData notification,
  });
}

class NotificationDSImpl implements NotificationDS {
  @override
  Future<Unit> sendBulkNotification({
    required List<String> userIds,
    required NotificationData notification,
  }) async {
    //
    for (var id in userIds) {
      await sendNotification(
        userId: id,
        notification: notification,
      );
    }
    //
    return unit;
  }

  @override
  Future<Unit> sendNotification({
    required String userId,
    required NotificationData notification,
  }) async {
    //
    final client = Supabase.instance.client;
    //
    var res = await client.from("users_data").select("notifications").eq("uuid", userId);
    //
    if (res.isNotEmpty) {
      //
      List notifications = res.first["notifications"] ?? [];
      //
      notifications.add(NotificationDataModel.fromClass(notification).toJson());

      //
      await client.from("users_data").update({"notifications": notifications}).eq("uuid", userId);
    }
    //
    return unit;
  }
}
