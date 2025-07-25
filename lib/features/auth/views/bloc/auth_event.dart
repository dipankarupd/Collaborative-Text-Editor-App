part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent({required this.email, required this.password});
}

class AuthRegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  AuthRegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class AuthLoginWithGoogleEvent extends AuthEvent {
  final String name;
  final String email;

  AuthLoginWithGoogleEvent({required this.name, required this.email});
}

class AuthIsLoggedInEvent extends AuthEvent {}
