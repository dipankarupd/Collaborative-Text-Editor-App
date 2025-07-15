import 'package:app/features/docs/domain/entity/doc_entity.dart';

class DocumentModel extends Document {
  DocumentModel({
    required super.id,
    required AuthorModel super.author,
    required super.title,
    required super.content,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'author': (author as AuthorModel).toJson(),
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(), // Consistent format
      'updated_at': updatedAt.toIso8601String(), // Consistent format
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> map) {
    try {
      return DocumentModel(
        id: map['id'] as String,
        author: AuthorModel.fromJson(map['author'] as Map<String, dynamic>),
        title: map['title'] as String,
        content: List<dynamic>.from(map['content'] as List),
        createdAt: DateTime.parse(
          map['created_at'] as String,
        ), // Match JSON key
        updatedAt: DateTime.parse(
          map['updated_at'] as String,
        ), // Match JSON key
      );
    } catch (e) {
      throw FormatException('Failed to parse Document: $e');
    }
  }
}

// Author Model
class AuthorModel extends Author {
  AuthorModel({required super.id, required super.name});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'name': name};
  }

  factory AuthorModel.fromJson(Map<String, dynamic> map) {
    try {
      return AuthorModel(id: map['id'] as String, name: map['name'] as String);
    } catch (e) {
      throw FormatException('Failed to parse Author: $e');
    }
  }
}
