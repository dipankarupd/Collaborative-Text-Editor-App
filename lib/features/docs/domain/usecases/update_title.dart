import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/docs/domain/repo/doc_repo.dart';
import 'package:app/utils/errors.dart';
import 'package:fpdart/src/either.dart';

class UpdateTitle implements Usecase<String, UpdateTitleParams> {
  final DocRepo repo;

  UpdateTitle({required this.repo});
  @override
  Future<Either<Failure, String>> call(UpdateTitleParams params) async {
    return await repo.updateDocumentTitle(
      documentId: params.documentId,
      title: params.title,
    );
  }
}

class UpdateTitleParams {
  final String documentId;
  final String title;

  UpdateTitleParams({required this.documentId, required this.title});
}
