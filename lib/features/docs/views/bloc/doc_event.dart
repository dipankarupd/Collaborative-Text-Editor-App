part of 'doc_bloc.dart';

@immutable
sealed class DocEvent {}

class FetchDocsEvent extends DocEvent {}

class DocSignoutEvent extends DocEvent {}

class DocCreateEvent extends DocEvent {}

class DocUpdateTitleEvent extends DocEvent {
  final String documentId;
  final String title;

  DocUpdateTitleEvent({required this.documentId, required this.title});
}

class DocGetDocumentByIdEvent extends DocEvent {
  final String documentId;

  DocGetDocumentByIdEvent({required this.documentId});
}

class DocJoinSocketEvent extends DocEvent {
  final String docId;

  DocJoinSocketEvent({required this.docId});
}

class DocSendMessageEvent extends DocEvent {
  final dynamic message;

  DocSendMessageEvent({required this.message});
}
