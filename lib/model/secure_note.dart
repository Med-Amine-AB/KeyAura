class SecureNote {
  final int? id;
  final String title;
  final String note;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  SecureNote({
    this.id,
    required this.title,
    required this.note,
    this.categoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'note': note,
        'category_id': categoryId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory SecureNote.fromMap(Map<String, dynamic> map) => SecureNote(
        id: map['id'],
        title: map['title'],
        note: map['note'],
        categoryId: map['category_id'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}