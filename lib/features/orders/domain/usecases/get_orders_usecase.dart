import 'package:dartz/dartz.dart' as dartz;
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUseCase {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  Future<dartz.Either<Failure, List<Order>>> call() {
    return repository.getOrders();
  }
}
