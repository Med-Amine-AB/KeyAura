class PhysicalCredential {
  final int? id;
  final String username;
  final String password;
  final String? color;
  final String? icon;
  final String? description;
  final int? categoryId;
  final int? providerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  PhysicalCredential({
    this.id,
    required this.username,
    required this.password,
    this.color,
    this.icon,
    this.description,
    this.categoryId,
    this.providerId,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'color': color,
        'icon': icon,
        'description': description,
        'category_id': categoryId,
        'provider_id': providerId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory PhysicalCredential.fromMap(Map<String, dynamic> map) => PhysicalCredential(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        color: map['color'],
        icon: map['icon'],
        description: map['description'],
        categoryId: map['category_id'],
        providerId: map['provider_id'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}