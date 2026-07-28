import 'dart:math';
import 'package:dartz/dartz.dart' as dartz;
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final List<Order> _orders = [];

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return 'ORD-$timestamp-$random';
  }

  @override
  Future<dartz.Either<Failure, Order>> createOrder(
    List<CartItem> items,
    double totalPrice,
  ) async {
    try {
      final order = Order(
        id: _generateOrderId(),
        items: List.unmodifiable(items),
        totalPrice: totalPrice,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _orders.add(order);
      return dartz.Right(order);
    } catch (e) {
      return dartz.Left(ServerFailure('Error al crear la orden: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, List<Order>>> getOrders() async {
    try {
      final sortedOrders = List<Order>.from(_orders)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return dartz.Right(List.unmodifiable(sortedOrders));
    } catch (e) {
      return dartz.Left(ServerFailure('Error al obtener órdenes: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final order = _orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('Orden no encontrada'),
      );
      return dartz.Right(order);
    } catch (e) {
      return dartz.Left(ServerFailure('Orden no encontrada: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index < 0) {
        return dartz.Left(ServerFailure('Orden no encontrada'));
      }

      final updatedOrder = _orders[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      _orders[index] = updatedOrder;
      return dartz.Right(updatedOrder);
    } catch (e) {
      return dartz.Left(ServerFailure('Error al actualizar estado: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index < 0) {
        return dartz.Left(ServerFailure('Orden no encontrada'));
      }

      final order = _orders[index];
      if (order.status == OrderStatus.cancelled ||
          order.status == OrderStatus.completed) {
        return dartz.Left(
          ServerFailure('No se puede cancelar una orden ${order.status.label}'),
        );
      }

      _orders[index] = order.copyWith(
        status: OrderStatus.cancelled,
        updatedAt: DateTime.now(),
      );

      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(ServerFailure('Error al cancelar orden: $e'));
    }
  }
}
