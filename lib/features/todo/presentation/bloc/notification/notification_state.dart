part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoadingState extends NotificationState {
  final String todoId;

  const NotificationLoadingState({required this.todoId});

  @override
  List<Object> get props => [todoId];
}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationMessageState extends NotificationState {
  final String message;

  const NotificationMessageState({required this.message});

  @override
  List<Object> get props => [message];
}
