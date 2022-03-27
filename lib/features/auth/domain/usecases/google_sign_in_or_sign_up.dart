import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInOrSignUp extends UseCase<User, NoParams> {
  final AuthRepository repository;

  GoogleSignInOrSignUp(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.googleSignInOrSignUp();
  }
}
