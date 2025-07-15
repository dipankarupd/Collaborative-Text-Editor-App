part of 'doc_bloc.dart';

@immutable
sealed class DocState {}

final class DocInitial extends DocState {}

final class DocLoadingState extends DocState {}

final class DocSignoutSuccessState extends DocState {}

final class DocErrorState extends DocState {
  final String message;
  final VoidCallback? retry;

  DocErrorState({required this.message, this.retry});
}

final class FetchDocSuccessState extends DocState {
  final List<Document> docs;

  FetchDocSuccessState({required this.docs});
}

final class CreateDocumentSuccessState extends DocState {
  final Document doc;

  CreateDocumentSuccessState({required this.doc});
}

final class DocumentTitleSuccessfullyUpdatedState extends DocState {
  final String newTitle;

  DocumentTitleSuccessfullyUpdatedState({required this.newTitle});
}

final class DocGetDocumentByIdSuccessState extends DocState {
  final Document document;

  DocGetDocumentByIdSuccessState({required this.document});
}

final class DocWebSocketMessageReceivedState extends DocState {
  final dynamic message;
  DocWebSocketMessageReceivedState({required this.message});
}
