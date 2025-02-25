class UserProfile {
  final int id;
  final String username;
  final String masterPasswordHash;
  final String? recoveryInfo;
  final String? settings;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    this.id = 1,
    required this.username,
    required this.masterPasswordHash,
    this.recoveryInfo,
    this.settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'master_password_hash': masterPasswordHash,
        'recovery_info': recoveryInfo,
        'settings': settings,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        id: map['id'],
        username: map['username'],
        masterPasswordHash: map['master_password_hash'],
        recoveryInfo: map['recovery_info'],
        settings: map['settings'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}