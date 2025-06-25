part of 'send_notification_bloc.dart';

abstract class SendNotificationEvent extends Equatable {
  const SendNotificationEvent();

  @override
  List<Object> get props => [];
}

class SendNotificationToUsers extends SendNotificationEvent {
  final List<String> userIds;
  final AppNotification notification;
  final File? imageFile;

  const SendNotificationToUsers({
    required this.userIds,
    required this.notification,
    this.imageFile,
  });

  @override
  List<Object> get props => [userIds, notification, imageFile ?? ''];
}

class SendNotificationToTopics extends SendNotificationEvent {
  final List<String> topics;
  final AppNotification notification;
  final File? imageFile;

  const SendNotificationToTopics({
    required this.topics,
    required this.notification,
    this.imageFile,
  });

  @override
  List<Object> get props => [topics, notification, imageFile ?? ''];
}
