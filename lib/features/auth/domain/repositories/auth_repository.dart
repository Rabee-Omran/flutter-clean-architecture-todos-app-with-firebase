import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginUser({required Map authData});
  Future<Either<Failure, User>> registerUser({required Map authData});
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> googleSignInOrSignUp();
  Future<Either<Failure, bool>> logout();
}
