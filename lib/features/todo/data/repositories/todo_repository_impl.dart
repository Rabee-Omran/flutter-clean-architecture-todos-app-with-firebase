import 'dart:math';

import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/notification_settings.dart';
import '../models/todo_model.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/todo.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_data_source.dart';
import '../datasources/todo_remote_data_source.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final NotificationService notificationService;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.notificationService,
  });

  @override
  Future<Either<Failure, void>> addNewTodo(Todo todo) async {
    if (await networkInfo.isConnected) {
      try {
        remoteDataSource.addTodo(TodoModel(
          complete: todo.complete,
          note: todo.note,
          task: todo.task,
          imageFile: todo.imageFile,
          imageUrl: todo.imageUrl,
        ));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(Todo todo) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteTodo(TodoModel(
            id: todo.id,
            complete: todo.complete,
            note: todo.note,
            task: todo.task));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      } catch (e) {
        return Left(NotFoundFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Stream<List<Todo>>>> todos() async {
    if (await networkInfo.isConnected) {
      try {
        Stream<List<Todo>> todos = remoteDataSource.todos();
        return Right(todos);
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTodo(Todo todo) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateTodo(TodoModel(
            id: todo.id,
            complete: todo.complete,
            note: todo.note,
            imageFile: todo.imageFile,
            imageUrl: todo.imageUrl,
            task: todo.task));
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      } catch (e) {
        return Left(NotFoundFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> disableNotification(
      NotificationParams notification) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.disableNotification(notification);
        await notificationService
            .cancelNotifications(notification.todo.notificationId!);
        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      } catch (e) {
        return Left(NotFoundFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, void>> enableNotification(
      NotificationParams notification) async {
    if (await networkInfo.isConnected) {
      try {
        final notificationId =
            Random(DateTime.now().microsecondsSinceEpoch).nextInt(99999);

        await remoteDataSource.enabelNotification(
            todoModel: TodoModel(
                id: notification.todo.id,
                complete: notification.todo.complete,
                note: notification.todo.note,
                task: notification.todo.task),
            notificationId: notificationId);

        await notificationService.scheduleNotifications(
            dateTime: notification.datetime!,
            body: notification.todo.task,
            todoId: notification.todo.id!,
            title: " 💡 " + "Reminder !",
            id: notificationId);

        return Future.value(Right(Unit));
      } on ServerException {
        return Left(ServerFailure());
      } on FirebaseDataException catch (error) {
        return Left(FirebaseDataFailure(error.message));
      } catch (e) {
        if (e.runtimeType == ArgumentError) {
          await remoteDataSource.disableNotification(notification);
          return Left(InvalidDateFailure());
        }

        return Left(NotFoundFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
