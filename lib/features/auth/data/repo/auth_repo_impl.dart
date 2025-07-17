import 'package:app/common/entity/user_entity.dart';
import 'package:app/common/exceptions/app_exception.dart';
import 'package:app/features/auth/data/source/auth_remote_source.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteSource source;

  AuthRepoImpl({required this.source});
  @override
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final res = await source.register(
        name: name,
        email: email,
        password: password,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await source.login(email: email, password: password);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getLoggedInUser() async {
    try {
      final res = await source.currentUser();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await source.logout();
      return right(null);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> signinWithGoogle({
    required String name,
    required String email,
  }) async {
    try {
      final res = await source.signinWithGoogle(name: name, email: email);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }
}
