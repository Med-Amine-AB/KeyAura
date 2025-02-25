class Category {
  final int? id;
  final String name;
  final String? description;
  final String? icon;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    this.id,
    required this.name,
    this.description,
    this.icon,
    this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'color': color,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        icon: map['icon'],
        color: map['color'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}