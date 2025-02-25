class CreditCard {
  final int? id;
  final String cardHolder;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final String? creditCardPassword;
  final String? color;
  final String? icon;
  final String? description;
  final int? categoryId;
  final int? providerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreditCard({
    this.id,
    required this.cardHolder,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    this.creditCardPassword,
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
        'card_holder': cardHolder,
        'card_number': cardNumber,
        'expiry_date': expiryDate,
        'cvv': cvv,
        'credit_card_password': creditCardPassword,
        'color': color,
        'icon': icon,
        'description': description,
        'category_id': categoryId,
        'provider_id': providerId,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  factory CreditCard.fromMap(Map<String, dynamic> map) => CreditCard(
        id: map['id'],
        cardHolder: map['card_holder'],
        cardNumber: map['card_number'],
        expiryDate: map['expiry_date'],
        cvv: map['cvv'],
        creditCardPassword: map['credit_card_password'],
        color: map['color'],
        icon: map['icon'],
        description: map['description'],
        categoryId: map['category_id'],
        providerId: map['provider_id'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
      );
}