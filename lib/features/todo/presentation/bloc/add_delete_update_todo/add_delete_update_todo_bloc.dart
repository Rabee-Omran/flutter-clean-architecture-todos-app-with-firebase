import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messages.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/add_todo.dart';
import '../../../domain/usecases/delete_todo.dart';
import '../../../domain/usecases/update_todo.dart';

part 'add_delete_update_todo_event.dart';
part 'add_delete_update_todo_state.dart';

class AddDeleteUpdateTodoBloc
    extends Bloc<AddDeleteUpdateTodoEvent, AddDeleteUpdateTodoState> {
  final AddTodoUsecase addTodo;
  final UpdateTodoUsecase updateTodo;
  final DeleteTodoUsecase deleteTodo;
  AddDeleteUpdateTodoBloc(
      {required this.updateTodo,
      required this.addTodo,
      required this.deleteTodo})
      : super(TodoInitialState()) {
    on<AddDeleteUpdateTodoEvent>((event, emit) async {
      if (event is AddTodoEvent) {
        emit(TodoLoadingState());
        final failureOrDone = await addTodo(event.todo);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: ADD_SUSCESS_MESSAGE));
      } else if (event is UpdateTodoEvent) {
        emit(TodoLoadingState());
        final failureOrDone = await updateTodo(event.todo);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: UPDATE_SUSCESS_MESSAGE));
      } else if (event is DeleteTodoEvent) {
        emit(TodoLoadingState());
        final failureOrDone = await deleteTodo(event.todo);
        emit(_eitherFailureOrDone(
            either: failureOrDone, successMessage: DELETE_SUSCESS_MESSAGE));
      }
    });
  }

  AddDeleteUpdateTodoState _eitherFailureOrDone(
      {required Either<Failure, void> either, required String successMessage}) {
    return either.fold(
      (failure) => TodoErrorState(message: _mapFailureToMessage(failure)),
      (_) => TodoMessageState(message: successMessage),
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
      case FirebaseDataFailure:
        final FirebaseDataFailure _firebaseFailure =
            failure as FirebaseDataFailure;
        return _firebaseFailure.message;
      default:
        return 'Unexpected Error, Please try again later .';
    }
  }
}
