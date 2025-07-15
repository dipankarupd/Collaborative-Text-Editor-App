import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class Logout implements Usecase<void, NoParams> {
  final AuthRepo repo;

  Logout({required this.repo});
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repo.logout();
  }
}
