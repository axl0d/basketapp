import 'package:equatable/equatable.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';

enum PaymentMethodType {
  cash('Efectivo'),
  card('Tarjeta');

  final String label;

  const PaymentMethodType(this.label);
}

class PaymentMethodSelection extends Equatable {
  final PaymentMethodType type;
  final PaymentCard? card;

  const PaymentMethodSelection({
    required this.type,
    this.card,
  });

  factory PaymentMethodSelection.cash() =>
      const PaymentMethodSelection(type: PaymentMethodType.cash);

  factory PaymentMethodSelection.card(PaymentCard card) =>
      PaymentMethodSelection(type: PaymentMethodType.card, card: card);

  @override
  List<Object?> get props => [type, card];
}
