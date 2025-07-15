import 'package:app/common/entity/user_entity.dart';
import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/repo/auth_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class Me implements Usecase<User, NoParams> {
  final AuthRepo repo;

  Me({required this.repo});
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repo.getLoggedInUser();
  }
}
