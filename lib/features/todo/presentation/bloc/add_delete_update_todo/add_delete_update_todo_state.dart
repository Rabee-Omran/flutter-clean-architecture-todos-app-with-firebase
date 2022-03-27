part of 'add_delete_update_todo_bloc.dart';

abstract class AddDeleteUpdateTodoState extends Equatable {
  const AddDeleteUpdateTodoState();

  @override
  List<Object> get props => [];
}

class TodoInitialState extends AddDeleteUpdateTodoState {}

class TodoLoadingState extends AddDeleteUpdateTodoState {}

class TodoErrorState extends AddDeleteUpdateTodoState {
  final String message;

  const TodoErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TodoMessageState extends AddDeleteUpdateTodoState {
  final String message;

  const TodoMessageState({required this.message});

  @override
  List<Object> get props => [message];
}
