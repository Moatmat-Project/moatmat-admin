import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moatmat_admin/Core/errors/exceptions.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_topics_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/requests/send_notification_to_users_request.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_to_topics_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_to_users_usecase.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/app_notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/upload_notification_image_usecase.dart';

part 'send_notification_event.dart';
part 'send_notification_state.dart';
class SendNotificationBloc extends Bloc<SendNotificationEvent, SendNotificationState> {
  final SendNotificationToUsersUsecase _sendNotificationToUsersUsecase;
  final SendNotificationToTopicsUsecase _sendNotificationToTopicsUsecase;
  final UploadNotificationImageUsecase _uploadNotificationImageUsecase;

  SendNotificationBloc({
    required UploadNotificationImageUsecase uploadNotificationImageUsecase,
    required SendNotificationToUsersUsecase sendNotificationToUsersUsecase,
    required SendNotificationToTopicsUsecase sendNotificationToTopicsUsecase,
  })  : _sendNotificationToUsersUsecase = sendNotificationToUsersUsecase,
        _sendNotificationToTopicsUsecase = sendNotificationToTopicsUsecase,
        _uploadNotificationImageUsecase = uploadNotificationImageUsecase,
        super(SendNotificationInitial()) {
    on<SendNotificationToUsers>(_onSendNotificationToUsers);
    on<SendNotificationToTopics>(_onSendNotificationToTopics);
  }

  Future<void> _onSendNotificationToUsers(
    SendNotificationToUsers event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());
    await _handleNotificationSending(
      imageFile: event.imageFile,
      originalNotification: event.notification,
      onSend: (notification) {
        final request = SendNotificationToUsersRequest(
          notification: notification,
          userIds: event.userIds,
        );
        return _sendNotificationToUsersUsecase(sendNotificationRequest: request);
      },
      emit: emit,
    );
  }

  Future<void> _onSendNotificationToTopics(
    SendNotificationToTopics event,
    Emitter<SendNotificationState> emit,
  ) async {
    emit(SendNotificationLoading());
    await _handleNotificationSending(
      imageFile: event.imageFile,
      originalNotification: event.notification,
      onSend: (notification) {
        final request = SendNotificationToTopicsRequest(
          notification: notification,
          topics: event.topics,
        );
        return _sendNotificationToTopicsUsecase(sendNotificationRequest: request);
      },
      emit: emit,
    );
  }

  Future<void> _handleNotificationSending({
    required File? imageFile,
    required AppNotification originalNotification,
    required Future<Either<Failure, Unit>> Function(AppNotification notification) onSend,
    required Emitter<SendNotificationState> emit,
  }) async {
    if (imageFile != null) {
      final uploadResult = await _uploadNotificationImageUsecase(imageFile: imageFile);
      await uploadResult.fold(
        (failure) async => emit(SendNotificationFailure("خطأ اثناء تحميل صورة الإشعار")),
        (imageUrl) async {
          final updatedNotification = originalNotification.copyWith(imageUrl: imageUrl);
          final sendResult = await onSend(updatedNotification);
          sendResult.fold(
            (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
            (_) => emit(SendNotificationSuccess()),
          );
        },
      );
    } else {
      final sendResult = await onSend(originalNotification);
      sendResult.fold(
        (failure) => emit(SendNotificationFailure("خطأ اثناء ارسال الإشعار")),
        (_) => emit(SendNotificationSuccess()),
      );
    }
  }
}
