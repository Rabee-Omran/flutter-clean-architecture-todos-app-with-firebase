import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Either<Failure, void>> addNewTodo(Todo todo);
  Future<Either<Failure, void>> deleteTodo(Todo todo);
  Future<Either<Failure, void>> updateTodo(Todo todo);
  Future<Either<Failure, void>> enableNotification(
      NotificationParams notification);
  Future<Either<Failure, void>> disableNotification(
      NotificationParams notification);
  Future<Either<Failure, Stream<List<Todo>>>> todos();
}
