import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class DocRepo {
  Future<Either<Failure, List<Document>>> getMyDocuments();
  Future<Either<Failure, Document>> createDocument();
  Future<Either<Failure, String>> updateDocumentTitle({
    required String documentId,
    required String title,
  });
  Future<Either<Failure, Document>> getDocumentById({
    required String documentId,
  });
}
