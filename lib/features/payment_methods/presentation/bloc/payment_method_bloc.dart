import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/payment_methods/domain/usecases/add_payment_card_usecase.dart';
import 'package:basketapp/features/payment_methods/domain/usecases/get_saved_cards_usecase.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_event.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetSavedCardsUseCase getSavedCardsUseCase;
  final AddPaymentCardUseCase addPaymentCardUseCase;

  PaymentMethodBloc({
    required this.getSavedCardsUseCase,
    required this.addPaymentCardUseCase,
  }) : super(const PaymentMethodInitial()) {
    on<GetSavedCardsEvent>(_onGetSavedCards);
    on<AddPaymentCardEvent>(_onAddPaymentCard);
  }

  Future<void> _onGetSavedCards(GetSavedCardsEvent event, Emitter<PaymentMethodState> emit) async {
    emit(const PaymentMethodLoading());
    final result = await getSavedCardsUseCase();
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (cards) => emit(PaymentMethodCardsLoaded(cards)),
    );
  }

  Future<void> _onAddPaymentCard(AddPaymentCardEvent event, Emitter<PaymentMethodState> emit) async {
    emit(const PaymentMethodLoading());
    final result = await addPaymentCardUseCase(event.card);
    result.fold(
      (failure) => emit(PaymentMethodError(failure.message)),
      (card) => emit(PaymentCardAdded(card)),
    );
  }
}
