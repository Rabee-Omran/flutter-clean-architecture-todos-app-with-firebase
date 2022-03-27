import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/failures.dart';
import '../../../../core/strings/messages.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/google_sign_in_or_sign_up.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final GoogleSignInOrSignUp googleSignInOrSignUp;
  final Logout logout;

  AuthBloc({
    required this.getCurrentUser,
    required this.loginUser,
    required this.registerUser,
    required this.googleSignInOrSignUp,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginUserEvent) {
        emit(AuthLoadingState());
        final failureOrUser = await loginUser(
          event.authData,
        );
        emit(_eitherFailureOrUser(failureOrUser));
      } else if (event is RegisterUserEvent) {
        emit(AuthLoadingState());
        final failureOrUser = await registerUser(
          event.authData,
        );
        emit(_eitherFailureOrUser(failureOrUser));
      } else if (event is GoogleSignInSignUp) {
        emit(AuthLoadingState());
        final failureOrUser = await googleSignInOrSignUp(NoParams());
        emit(_eitherFailureOrUser(failureOrUser));
      } else if (event is GetCurrentUserEvent) {
        emit(AuthLoadingState());
        final failureOrUser = await getCurrentUser(NoParams());
        emit(failureOrUser.fold(
          (_) => AuthInitial(),
          (user) => LoadedUserState(user: user),
        ));
      } else if (event is LogoutEvent) {
        emit(AuthLoadingState());
        final failureOrDone = await logout(NoParams());
        emit(failureOrDone.fold(
          (failure) => AuthErrorState(message: _mapFailureToMessage(failure)),
          (isDone) => const MessageState(message: LOGOUT_MESSAGE),
        ));
      }
    });
  }
}

AuthState _eitherFailureOrUser(Either<Failure, User> either) {
  return either.fold(
    (failure) => AuthErrorState(message: _mapFailureToMessage(failure)),
    (user) => LoadedUserState(user: user),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    case OfflineFailure:
      return OFFLINE_FAILURE_MESSAGE;
    case CanceledByUserFailure:
      return CANCELED_BY_USER_FAILURE_MESSAGE;
    case InvalidDataFailure:
      return INVALID_DATA_FAILURE_MESSAGE;
    case FirebaseDataFailure:
      final FirebaseDataFailure _firebaseFailure =
          failure as FirebaseDataFailure;
      return _firebaseFailure.message;
    default:
      return 'Unexpected Error, Please try again later .';
  }
}
