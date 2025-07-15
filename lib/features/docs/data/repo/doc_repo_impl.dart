import 'package:app/common/exceptions/app_exception.dart';
import 'package:app/features/docs/data/source/doc_remote.dart';
import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/features/docs/domain/repo/doc_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class DocRepoImpl implements DocRepo {
  final DocRemoteSource source;

  DocRepoImpl({required this.source});

  @override
  Future<Either<Failure, List<Document>>> getMyDocuments() async {
    try {
      final res = await source.getMyDocuments();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, Document>> createDocument() async {
    try {
      final res = await source.createDocument();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updateDocumentTitle({
    required String documentId,
    required String title,
  }) async {
    try {
      final res = await source.updateDocumentTitle(
        documentId: documentId,
        title: title,
      );
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }

  @override
  Future<Either<Failure, Document>> getDocumentById({
    required String documentId,
  }) async {
    try {
      final res = await source.getDocumentById(documentId: documentId);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(msg: e.message.toString()));
    }
  }
}
