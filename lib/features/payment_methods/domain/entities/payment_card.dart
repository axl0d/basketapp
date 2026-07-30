import 'package:equatable/equatable.dart';

enum CardBrand {
  visa('Visa'),
  mastercard('Mastercard'),
  amex('American Express'),
  other('Tarjeta');

  final String label;

  const CardBrand(this.label);
}

class PaymentCard extends Equatable {
  final String id;
  final String cardholderName;
  final String last4;
  final CardBrand brand;
  final int expiryMonth;
  final int expiryYear;
  final DateTime createdAt;

  const PaymentCard({
    required this.id,
    required this.cardholderName,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.createdAt,
  });

  String get maskedNumber => '•••• •••• •••• $last4';

  PaymentCard copyWith({
    String? id,
    String? cardholderName,
    String? last4,
    CardBrand? brand,
    int? expiryMonth,
    int? expiryYear,
    DateTime? createdAt,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      cardholderName: cardholderName ?? this.cardholderName,
      last4: last4 ?? this.last4,
      brand: brand ?? this.brand,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    cardholderName,
    last4,
    brand,
    expiryMonth,
    expiryYear,
    createdAt,
  ];
}
