import 'dart:async';

import 'package:app/common/cubit/app_cubit_cubit.dart';
import 'package:app/common/entity/user_entity.dart';
import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/usecases/google_signin.dart';
import 'package:app/features/auth/domain/usecases/login.dart';
import 'package:app/features/auth/domain/usecases/me.dart';
import 'package:app/features/auth/domain/usecases/register.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final SignInWithGoogle _signInWithGoogle;
  final Register _register;
  final Me _me;
  final AppCubitCubit _appCubitCubit;
  AuthBloc({
    required Login login,
    required Register register,
    required Me me,
    required AppCubitCubit appCubitCubit,
    required SignInWithGoogle signinWithGoogle,
  }) : _login = login,
       _register = register,
       _me = me,
       _appCubitCubit = appCubitCubit,
       _signInWithGoogle = signinWithGoogle,
       super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(AuthLoadingState());
    });

    on<AuthLoginEvent>(authLoginEvent);
    on<AuthRegisterEvent>(authRegisterEvent);
    on<AuthIsLoggedInEvent>(authIsLoggedInEvent);
    on<AuthLoginWithGoogleEvent>(authLoginWithGoogleEvent);
  }

  FutureOr<void> authLoginEvent(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _login(
      LoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (error) {
        emit(AuthErrorState(errorMessage: error.msg));
      },
      (user) {
        _emitAuthSuccess(user.user, emit);
      },
    );
  }

  FutureOr<void> authRegisterEvent(
    AuthRegisterEvent event,
    Emitter emit,
  ) async {
    emit(AuthLoadingState());
    final res = await _register(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (fail) {
        emit(AuthErrorState(errorMessage: fail.msg));
      },
      (user) {
        _emitAuthSuccess(user.user, emit);
      },
    );
  }

  FutureOr<void> authIsLoggedInEvent(
    AuthIsLoggedInEvent event,
    Emitter emit,
  ) async {
    final res = await _me(NoParams());
    res.fold(
      (fail) {
        print('here');
        print(fail.msg);
        _appCubitCubit.logout();
        emit(AuthErrorState(errorMessage: fail.msg));
      },
      (user) {
        _emitAuthSuccess(user, emit);
        // emit(AuthSuccessState(user: user));
      },
    );
  }

  FutureOr<void> authLoginWithGoogleEvent(
    AuthLoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _signInWithGoogle(
      GoogleSigninParams(name: event.name, email: event.email),
    );

    res.fold(
      (error) {
        emit(AuthErrorState(errorMessage: error.msg));
      },
      (user) {
        _emitAuthSuccess(user.user, emit);
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter emit) {
    _appCubitCubit.getUser(user);
    emit(AuthSuccessState(user: user));
  }
}
