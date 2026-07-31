import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';
import 'package:basketapp/features/payment_methods/domain/repositories/payment_method_repository.dart';

class AddPaymentCardUseCase {
  final PaymentMethodRepository repository;

  AddPaymentCardUseCase(this.repository);

  Future<Either<Failure, PaymentCard>> call(PaymentCard card) {
    return repository.addCard(card);
  }
}
