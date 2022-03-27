import 'package:dartz/dartz.dart';
import '../repositories/todo_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';

class AddTodoUsecase extends UseCase<void, Todo> {
  final TodoRepository repository;

  AddTodoUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Todo todo) async {
    return await repository.addNewTodo(todo);
  }
}
