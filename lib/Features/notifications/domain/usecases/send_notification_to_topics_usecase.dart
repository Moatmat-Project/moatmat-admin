import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/repositories/notifications_repository.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_topics_request.dart';

class SendNotificationToTopicsUsecase {
  final NotificationsRepository repository;
  SendNotificationToTopicsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call({required SendNotificationToTopicsRequest sendNotificationRequest}) async {
    return repository.sendNotificationToTopics(
      sendNotificationRequest: sendNotificationRequest,
    );
  }
}
