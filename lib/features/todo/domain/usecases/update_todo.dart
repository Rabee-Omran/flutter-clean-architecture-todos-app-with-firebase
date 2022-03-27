import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class UpdateTodoUsecase extends UseCase<void, Todo> {
  final TodoRepository repository;

  UpdateTodoUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Todo todo) async {
    return await repository.updateTodo(todo);
  }
}
