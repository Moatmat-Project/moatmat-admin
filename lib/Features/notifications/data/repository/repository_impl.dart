import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Features/notifications/data/datasources/notifications_ds.dart';

import 'package:moatmat_admin/Features/notifications/domain/entities/notification.dart';

import '../../domain/repository/repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDS dataSource;

  NotificationRepositoryImpl({required this.dataSource});
  @override
  Future<Either<Exception, Unit>> sendBulkNotification({
    required List<String> userIds,
    required NotificationData notification,
  }) async {
    try {
      await dataSource.sendBulkNotification(
        userIds: userIds,
        notification: notification,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }

  @override
  Future<Either<Exception, Unit>> sendNotification({
    required String userId,
    required NotificationData notification,
  }) async {
    try {
      await dataSource.sendNotification(
        userId: userId,
        notification: notification,
      );
      return right(unit);
    } on Exception catch (e) {
      return left(e);
    }
  }
}
