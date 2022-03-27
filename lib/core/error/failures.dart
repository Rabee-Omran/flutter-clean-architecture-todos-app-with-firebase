import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]) : super();
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidDataFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CanceledByUserFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class NotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class FirebaseDataFailure extends Failure {
  final String message;

  FirebaseDataFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class InvalidDateFailure extends Failure {
  @override
  List<Object?> get props => [];
}
