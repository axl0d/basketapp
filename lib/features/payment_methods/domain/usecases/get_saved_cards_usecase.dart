import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';
import 'package:basketapp/features/payment_methods/domain/repositories/payment_method_repository.dart';

class GetSavedCardsUseCase {
  final PaymentMethodRepository repository;

  GetSavedCardsUseCase(this.repository);

  Future<Either<Failure, List<PaymentCard>>> call() {
    return repository.getSavedCards();
  }
}
