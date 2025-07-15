import 'package:app/common/exceptions/app_exception.dart';
import 'package:app/config/constants/endpoints.dart';
import 'package:app/features/docs/data/model/doc_model.dart';
import 'package:app/utils/logger.dart';
import 'package:dio/dio.dart';

abstract interface class DocRemoteSource {
  Future<List<DocumentModel>> getMyDocuments();
  Future<DocumentModel> createDocument();
  Future<String> updateDocumentTitle({
    required String documentId,
    required String title,
  });
  Future<DocumentModel> getDocumentById({required String documentId});
}

class DocRemoteSourceImpl implements DocRemoteSource {
  final Dio dio;

  DocRemoteSourceImpl({required this.dio});

  @override
  Future<List<DocumentModel>> getMyDocuments() async {
    try {
      final endpoint = AppEndpoints.DOCUMENTS;

      LoggerUtils.logRequest("My Documents", endpoint);

      final res = await dio.get(endpoint);

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess('My Documents', res.statusCode, res.data);

        // get the list of document model and return
        final List<dynamic> data = res.data as List;
        return data.map((json) => DocumentModel.fromJson(json)).toList();
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError('My Documents', (e.error as AppException).message);
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'My Documents',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<DocumentModel> createDocument() async {
    try {
      final endpoint = AppEndpoints.CREATE;

      LoggerUtils.logRequest("Create Document", endpoint);

      final res = await dio.post(endpoint);

      if (res.statusCode == 201) {
        print('doc created success');
        LoggerUtils.logSuccess('Create Document', res.statusCode, res.data);

        // get the list of document model and return
        final data = res.data;
        return DocumentModel.fromJson(data);
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError(
          'Create Document',
          (e.error as AppException).message,
        );
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'Create Document',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<String> updateDocumentTitle({
    required String documentId,
    required String title,
  }) async {
    try {
      final endpoint = AppEndpoints.updateTitle(documentId);

      LoggerUtils.logRequest("Update Title", endpoint);

      final res = await dio.patch(endpoint, data: {"title": title});

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess('Update Title', res.statusCode, res.data);

        // get the list of document model and return
        final data = res.data['new_title'];
        return data as String;
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError('Update Title', (e.error as AppException).message);
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'Update Title',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }

  @override
  Future<DocumentModel> getDocumentById({required String documentId}) async {
    try {
      final endpoint = AppEndpoints.GetDocumentById(documentId);

      LoggerUtils.logRequest("Get Document By Id", endpoint);

      final res = await dio.get(endpoint);

      if (res.statusCode == 200) {
        LoggerUtils.logSuccess('Get Document By Id', res.statusCode, res.data);

        // get the list of document model and return
        final data = res.data;
        return DocumentModel.fromJson(data);
      } else {
        final error = res.data?['error'] as String?;
        final msg =
            error ?? 'Something went wrong. Status code: ${res.statusCode}';

        throw AppException(message: msg);
      }
    } catch (e) {
      // Check if it's a DioException wrapping an AppException (from interceptor)
      if (e is DioException && e.error is AppException) {
        LoggerUtils.logError('Update Title', (e.error as AppException).message);
        throw e.error as AppException;
      }

      LoggerUtils.logError(
        'Get Document By Id',
        e is AppException ? e.message : e.toString(),
      );

      if (e is AppException) {
        rethrow;
      } else {
        throw AppException(message: "Something went wrong");
      }
    }
  }
}
