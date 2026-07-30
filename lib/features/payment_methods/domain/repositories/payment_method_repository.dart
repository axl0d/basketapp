import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, List<PaymentCard>>> getSavedCards();
  Future<Either<Failure, PaymentCard>> addCard(PaymentCard card);
}
