part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodosInitialState extends TodoState {}

class TodosLoadingState extends TodoState {}

class TodosErrorState extends TodoState {
  final String message;

  const TodosErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TodosMessageState extends TodoState {
  final String message;

  const TodosMessageState({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadedTodosState extends TodoState {
  final List<Todo> todos;

  LoadedTodosState({
    required this.todos,
  });

  @override
  List<Object> get props => [todos];
}
