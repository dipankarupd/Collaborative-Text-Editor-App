import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class Register implements Usecase<AuthEntity, RegisterParams> {
  final AuthRepo repo;

  Register({required this.repo});
  @override
  Future<Either<Failure, AuthEntity>> call(RegisterParams params) async {
    return await repo.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
