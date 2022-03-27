import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../features/todo/domain/entities/todo.dart';

import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

class Params extends Equatable {
  final int id;

  const Params({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class PaginationParams extends Equatable {
  final int start;
  final int limit;

  const PaginationParams({
    required this.start,
    required this.limit,
  });

  @override
  List<Object> get props => [start, limit];
}

class NotificationParams extends Equatable {
  final Todo todo;
  final DateTime? datetime;

  const NotificationParams({
    required this.todo,
    this.datetime,
  });

  @override
  List<Object> get props => [todo, datetime!];
}
