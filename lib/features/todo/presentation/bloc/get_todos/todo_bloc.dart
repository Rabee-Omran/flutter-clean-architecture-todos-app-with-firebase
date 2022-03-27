// ignore_for_file: cancel_subscriptions, invalid_use_of_visible_for_testing_member

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../domain/entities/todo.dart';
import '../../../domain/usecases/get_todos.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUsecase getTodos;
  StreamSubscription? todosStreamSubscription;
  TodoBloc({
    required this.getTodos,
  }) : super(TodosInitialState()) {
    on<TodoEvent>((event, emit) async {
      if (event is GetAllTodosEvent) {
        emit(TodosLoadingState());
        final failureOrDone = await getTodos();
        failureOrDone.fold(
            (failure) =>
                emit(TodosErrorState(message: _mapFailureToMessage(failure))),
            (todos) {
          try {
            todosStreamSubscription!.cancel();
          } catch (e) {}
          todosStreamSubscription = todos.listen((todosList) {
            emitLoadedTodos(todosList);
          });
        });
      }
    });
  }
  void emitLoadedTodos(todos) => emit(LoadedTodosState(todos: todos));

  @override
  Future<void> close() async {
    todosStreamSubscription!.cancel();
    return super.close();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
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
