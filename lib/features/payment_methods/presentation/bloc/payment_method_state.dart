import 'package:equatable/equatable.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object?> get props => [];
}

class PaymentMethodInitial extends PaymentMethodState {
  const PaymentMethodInitial();
}

class PaymentMethodLoading extends PaymentMethodState {
  const PaymentMethodLoading();
}

class PaymentMethodCardsLoaded extends PaymentMethodState {
  final List<PaymentCard> cards;

  const PaymentMethodCardsLoaded(this.cards);

  @override
  List<Object?> get props => [cards];
}

class PaymentCardAdded extends PaymentMethodState {
  final PaymentCard card;

  const PaymentCardAdded(this.card);

  @override
  List<Object?> get props => [card];
}

class PaymentMethodError extends PaymentMethodState {
  final String message;

  const PaymentMethodError(this.message);

  @override
  List<Object?> get props => [message];
}
