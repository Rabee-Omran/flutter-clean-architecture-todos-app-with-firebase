part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [props];
}

class RegisterUserEvent extends AuthEvent {
  final Map authData;

  RegisterUserEvent(this.authData) : super([authData]);
}

class LoginUserEvent extends AuthEvent {
  final Map authData;

  LoginUserEvent(this.authData) : super([authData]);
}

class GetCurrentUserEvent extends AuthEvent {}

class GoogleSignInSignUp extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
