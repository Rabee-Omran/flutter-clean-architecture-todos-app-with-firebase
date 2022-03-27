import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/todo_repository.dart';

class DisableNotificationUsecase extends UseCase<void, NotificationParams> {
  final TodoRepository repository;

  DisableNotificationUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(NotificationParams notification) async {
    return await repository.disableNotification(notification);
  }
}
