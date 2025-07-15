import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/docs/domain/entity/doc_entity.dart' show Document;
import 'package:app/features/docs/domain/repo/doc_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class GetDocumentById implements Usecase<Document, GetDocumentByIdParams> {
  final DocRepo repo;

  GetDocumentById({required this.repo});

  @override
  Future<Either<Failure, Document>> call(GetDocumentByIdParams params) async {
    return await repo.getDocumentById(documentId: params.documentId);
  }
}

class GetDocumentByIdParams {
  final String documentId;

  GetDocumentByIdParams({required this.documentId});
}
