import 'package:dartz/dartz.dart' as dartz;
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';

class CancelOrderUseCase {
  final OrderRepository repository;

  CancelOrderUseCase(this.repository);

  Future<dartz.Either<Failure, void>> call(String orderId) {
    return repository.cancelOrder(orderId);
  }
}
