import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moatmat_admin/Core/injection/app_inj.dart';
import 'package:moatmat_admin/Features/notifications/domain/entities/notification.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_bulk_notification_uc.dart';
import 'package:moatmat_admin/Features/notifications/domain/usecases/send_notification_uc.dart';
import 'package:moatmat_admin/Features/students/domain/entities/user_data.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsLoading());

  sendNotification({
    required UserData userData,
    required NotificationData notification,
  }) async {
    //
    emit(NotificationsLoading());
    //
    final res = await locator<SendNotification>().call(
      userId: userData.uuid,
      notification: notification,
    );
    //
    res.fold(
      (l) => emit(NotificationsError(error: l.toString())),
      (r) {
        emit(NotificationsSuccess());
      },
    );
    //
  }

  sendBulkNotification({
    required List<UserData> userData,
    required NotificationData notification,
  }) async {
    //
    emit(NotificationsLoading());
    //
    final res = await locator<SendBulkNotification>().call(
      userIds: userData.map((e) => e.uuid).toList(),
      notification: notification,
    );
    //
    res.fold(
      (l) => emit(NotificationsError(error: l.toString())),
      (r) {
        emit(NotificationsSuccess());
      },
    );
    //
  }

  emitNotification() {
    //
    emit(NotificationsLoading());
    //
    emit(NotificationsNotification());
  }

  emitBulkNotification() {
    //
    emit(NotificationsLoading());
    //
    emit(NotificationsBulkNotification());
  }
}
