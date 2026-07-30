import 'package:equatable/equatable.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';

abstract class PaymentMethodEvent extends Equatable {
  const PaymentMethodEvent();

  @override
  List<Object?> get props => [];
}

class GetSavedCardsEvent extends PaymentMethodEvent {
  const GetSavedCardsEvent();
}

class AddPaymentCardEvent extends PaymentMethodEvent {
  final PaymentCard card;

  const AddPaymentCardEvent(this.card);

  @override
  List<Object?> get props => [card];
}
