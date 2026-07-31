import 'package:dartz/dartz.dart' as dartz;
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';

class GetOrderByIdUseCase {
  final OrderRepository repository;

  GetOrderByIdUseCase(this.repository);

  Future<dartz.Either<Failure, Order>> call(String orderId) {
    return repository.getOrderById(orderId);
  }
}
