part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsSuccess extends NotificationsState {}

final class NotificationsError extends NotificationsState {
  final String error;

  const NotificationsError({required this.error});
}

final class NotificationsNotification extends NotificationsState {}

final class NotificationsBulkNotification extends NotificationsState {}
