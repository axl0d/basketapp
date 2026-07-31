import 'package:hive/hive.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';

part 'payment_card_hive_model.g.dart';

@HiveType(typeId: 3)
class PaymentCardHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String cardholderName;

  @HiveField(2)
  final String last4;

  @HiveField(3)
  final int brandIndex;

  @HiveField(4)
  final int expiryMonth;

  @HiveField(5)
  final int expiryYear;

  @HiveField(6)
  final DateTime createdAt;

  PaymentCardHiveModel({
    required this.id,
    required this.cardholderName,
    required this.last4,
    required this.brandIndex,
    required this.expiryMonth,
    required this.expiryYear,
    required this.createdAt,
  });

  PaymentCard toEntity() => PaymentCard(
    id: id,
    cardholderName: cardholderName,
    last4: last4,
    brand: CardBrand.values[brandIndex],
    expiryMonth: expiryMonth,
    expiryYear: expiryYear,
    createdAt: createdAt,
  );

  factory PaymentCardHiveModel.fromEntity(PaymentCard card) => PaymentCardHiveModel(
    id: card.id,
    cardholderName: card.cardholderName,
    last4: card.last4,
    brandIndex: card.brand.index,
    expiryMonth: card.expiryMonth,
    expiryYear: card.expiryYear,
    createdAt: card.createdAt,
  );
}
