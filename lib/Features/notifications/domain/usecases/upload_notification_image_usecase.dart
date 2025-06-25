import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/repositories/notifications_repository.dart';

class UploadNotificationImageUsecase {
  final NotificationsRepository repository;

  UploadNotificationImageUsecase({required this.repository});

  Future<Either<Failure, String>> call({required File imageFile}) async {
    return repository.uploadNotificationImage(imageFile: imageFile);
  }
}
