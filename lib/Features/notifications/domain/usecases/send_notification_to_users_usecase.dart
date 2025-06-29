import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/repositories/notifications_repository.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_users_request.dart';

class SendNotificationToUsersUsecase {
  final NotificationsRepository repository;
  SendNotificationToUsersUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({
    required SendNotificationToUsersRequest sendNotificationRequest,
  }) async {
    return repository.sendNotificationToUsers(
      sendNotificationRequest: sendNotificationRequest,
    );
  }
}
