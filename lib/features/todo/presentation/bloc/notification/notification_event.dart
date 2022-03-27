part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class EnableNotificationEvent extends NotificationEvent {
 final NotificationParams notification;

  EnableNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class DisableNotificationEvent extends NotificationEvent {
  final NotificationParams notification;

  DisableNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}
