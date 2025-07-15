class Document {
  final String id;
  final Author author;
  final String title;
  final List content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Document({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Author {
  final String id;
  final String name;

  Author({required this.id, required this.name});
}
