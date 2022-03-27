part of 'add_delete_update_todo_bloc.dart';

abstract class AddDeleteUpdateTodoEvent extends Equatable {
  const AddDeleteUpdateTodoEvent();

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends AddDeleteUpdateTodoEvent {
  final Todo todo;

  AddTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class UpdateTodoEvent extends AddDeleteUpdateTodoEvent {
  final Todo todo;

  UpdateTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodoEvent extends AddDeleteUpdateTodoEvent {
  final Todo todo;

  DeleteTodoEvent(this.todo);

  @override
  List<Object> get props => [todo];
}
