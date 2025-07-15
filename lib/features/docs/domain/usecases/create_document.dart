import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/features/docs/domain/repo/doc_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class CreateDocument implements Usecase<Document, NoParams> {
  final DocRepo repo;

  CreateDocument({required this.repo});
  @override
  Future<Either<Failure, Document>> call(NoParams params) async {
    return await repo.createDocument();
  }
}
