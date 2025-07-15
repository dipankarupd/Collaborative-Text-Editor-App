import 'dart:async';
import 'dart:ui';
import 'package:app/common/usecase/usecases.dart';
import 'package:app/features/auth/domain/usecases/logout.dart';
import 'package:app/features/docs/domain/entity/doc_entity.dart';
import 'package:app/features/docs/domain/usecases/create_document.dart';
import 'package:app/features/docs/domain/usecases/get_all_documents.dart';
import 'package:app/features/docs/domain/usecases/get_document_by_id.dart';
import 'package:app/features/docs/domain/usecases/update_title.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'doc_event.dart';
part 'doc_state.dart';

class DocBloc extends Bloc<DocEvent, DocState> {
  final Logout _logout;
  final GetAllDocuments _getAllDocuments;
  final CreateDocument _createDocument;
  final UpdateTitle _updateTitle;
  final GetDocumentById _getDocumentById;

  DocBloc({
    required Logout logout,
    required GetAllDocuments getAllDocuments,
    required CreateDocument createDocument,
    required UpdateTitle updateTitle,
    required GetDocumentById getDocumentById,
  }) : _logout = logout,
       _getAllDocuments = getAllDocuments,
       _createDocument = createDocument,
       _updateTitle = updateTitle,
       _getDocumentById = getDocumentById,
       super(DocInitial()) {
    // Remove the global loading state emission
    on<DocSignoutEvent>(docSignoutEvent);
    on<FetchDocsEvent>(fetchDocsEvent);
    on<DocCreateEvent>(createDocumentEvent);
    on<DocUpdateTitleEvent>(updateTitleEvent);
    on<DocGetDocumentByIdEvent>(docGetDocumentByIdEvent);
  }

  FutureOr<void> docSignoutEvent(DocEvent event, Emitter emit) async {
    emit(DocLoadingState());
    final res = await _logout(NoParams());

    res.fold(
      (fail) {
        emit(DocErrorState(message: fail.msg));
      },
      (res) {
        emit(DocSignoutSuccessState());
      },
    );
  }

  FutureOr<void> fetchDocsEvent(DocEvent event, Emitter emit) async {
    emit(DocLoadingState());
    final res = await _getAllDocuments(NoParams());

    res.fold(
      (fail) => emit(DocErrorState(message: fail.msg)),
      (res) => emit(FetchDocSuccessState(docs: res)),
    );
  }

  FutureOr<void> createDocumentEvent(DocCreateEvent event, Emitter emit) async {
    emit(DocLoadingState());
    final res = await _createDocument(NoParams());
    res.fold(
      (fail) => emit(DocErrorState(message: fail.msg)),
      (doc) => emit(CreateDocumentSuccessState(doc: doc)),
    );
  }

  FutureOr<void> updateTitleEvent(
    DocUpdateTitleEvent event,
    Emitter emit,
  ) async {
    final res = await _updateTitle(
      UpdateTitleParams(documentId: event.documentId, title: event.title),
    );

    res.fold(
      (fail) => emit(DocErrorState(message: fail.msg)),
      (title) => emit(DocumentTitleSuccessfullyUpdatedState(newTitle: title)),
    );
  }

  FutureOr<void> docGetDocumentByIdEvent(
    DocGetDocumentByIdEvent event,
    Emitter<DocState> emit,
  ) async {
    final res = await _getDocumentById(
      GetDocumentByIdParams(documentId: event.documentId),
    );

    res.fold(
      (fail) => emit(DocErrorState(message: fail.msg)),
      (doc) => emit(DocGetDocumentByIdSuccessState(document: doc)),
    );
  }

  // FutureOr<void> docJoinSocketEvent(
  //   DocJoinSocketEvent event,
  //   Emitter<DocState> emit,
  // ) {
  //   service.connect(event.docId);
  // }
}
