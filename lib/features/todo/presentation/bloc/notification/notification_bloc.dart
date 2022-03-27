import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/disable_notification.dart';
import '../../../domain/usecases/enable_notification.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final EnableNotificationUsecase enableNotification;
  final DisableNotificationUsecase disableNotification;

  NotificationBloc({
    required this.enableNotification,
    required this.disableNotification,
  }) : super(NotificationInitial()) {
    on<NotificationEvent>((event, emit) async {
      if (event is EnableNotificationEvent) {
        emit(NotificationLoadingState(todoId: event.notification.todo.id!));
        final failureOrDone = await enableNotification(event.notification);
        emit(_eitherFailureOrDone(either: failureOrDone));
      } else if (event is DisableNotificationEvent) {
        emit(NotificationLoadingState(todoId: event.notification.todo.id!));
        final failureOrDone = await disableNotification(event.notification);
        emit(_eitherFailureOrDone(either: failureOrDone));
      }
    });
  }

  NotificationState _eitherFailureOrDone(
      {required Either<Failure, void> either}) {
    return either.fold(
      (failure) =>
          NotificationErrorState(message: _mapFailureToMessage(failure)),
      (_) => NotificationMessageState(message: DONE_SUSCESS_MESSAGE),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case NotFoundFailure:
        return NOT_FOUND_FAILURE_MESSAGE;
      case InvalidDataFailure:
        return INVALID_DATA_FAILURE_MESSAGE;
      case InvalidDateFailure:
        return INVALID_DATE_FAILURE_MESSAGE;
      case FirebaseDataFailure:
        final FirebaseDataFailure _firebaseFailure =
            failure as FirebaseDataFailure;
        return _firebaseFailure.message;
      default:
        return 'Unexpected Error, Please try again later .';
    }
  }
}
