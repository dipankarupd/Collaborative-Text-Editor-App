import 'package:app/common/entity/user_entity.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepo {
  Future<Either<Failure, AuthEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getLoggedInUser();

  Future<Either<Failure, void>> logout();
}
