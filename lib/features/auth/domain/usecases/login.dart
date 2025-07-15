import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class Login implements Usecase<AuthEntity, LoginParams> {
  final AuthRepo repo;

  Login({required this.repo});
  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return await repo.signIn(email: params.email, password: params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
