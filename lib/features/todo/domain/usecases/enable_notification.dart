import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class EnableNotificationUsecase extends UseCase<void, NotificationParams> {
  final TodoRepository repository;

  EnableNotificationUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(NotificationParams notification) async {
    return await repository.enableNotification(notification);
  }
}
