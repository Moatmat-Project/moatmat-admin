part of 'send_notification_bloc.dart';

abstract class SendNotificationState extends Equatable {
  const SendNotificationState();

  @override
  List<Object> get props => [];
}

class SendNotificationInitial extends SendNotificationState {}

class SendNotificationLoading extends SendNotificationState {}

class SendNotificationSuccess extends SendNotificationState {}

class SendNotificationFailure extends SendNotificationState {
  final String message;

  const SendNotificationFailure(this.message);

  @override
  List<Object> get props => [message];
}
