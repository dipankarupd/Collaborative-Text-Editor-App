part of 'app_cubit_cubit.dart';

@immutable
sealed class AppCubitState {}

final class AppCubitInitial extends AppCubitState {}

class AppUserLoggedInState extends AppCubitState {
  final User user;

  AppUserLoggedInState({required this.user});
}

class AppUserLoggedOutState extends AppCubitState {}
