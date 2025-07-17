import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/entity/auth_entity.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class SignInWithGoogle implements Usecase<AuthEntity, GoogleSigninParams> {
  final AuthRepo repo;

  SignInWithGoogle({required this.repo});

  @override
  Future<Either<Failure, AuthEntity>> call(GoogleSigninParams params) async {
    return await repo.signinWithGoogle(name: params.name, email: params.email);
  }
}

class GoogleSigninParams {
  final String name;
  final String email;

  GoogleSigninParams({required this.name, required this.email});
}
