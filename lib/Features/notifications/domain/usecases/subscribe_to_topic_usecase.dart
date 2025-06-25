import 'package:dartz/dartz.dart';

import 'package:moatmat_admin/Core/errors/exceptions.dart';
import '../repositories/notifications_repository.dart';

class SubscribeToTopicUsecase {
  final NotificationsRepository repository;

  SubscribeToTopicUsecase({required this.repository});
  Future<Either<Failure, Unit>> call({required String topic}) async {
    return await repository.subscribeToTopic(topic: topic);
  }
}
