import 'dart:math';
import 'package:dartz/dartz.dart' as dartz;
import 'package:hive/hive.dart';
import 'package:basketapp/core/database/hive_boxes.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';
import 'package:basketapp/features/orders/data/models/order_hive_model.dart';

class OrderRepositoryHive extends OrderRepository {
  late final Box<OrderHiveModel> _ordersBox;

  OrderRepositoryHive() {
    _ordersBox = Hive.box<OrderHiveModel>(HiveBoxes.orders);
  }

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

      final hiveModel = OrderHiveModel.fromEntity(order);
      await _ordersBox.put(order.id, hiveModel);

      return dartz.Right(order);
    } catch (e) {
      return dartz.Left(LocalStorageFailure('Error al crear la orden: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, List<Order>>> getOrders() async {
    try {
      final hiveModels = _ordersBox.values.toList();
      final orders = hiveModels.map((model) => model.toEntity()).toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return dartz.Right(List.unmodifiable(orders));
    } catch (e) {
      return dartz.Left(LocalStorageFailure('Error al obtener órdenes: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final hiveModel = _ordersBox.get(orderId);

      if (hiveModel == null) {
        return dartz.Left(LocalStorageFailure('Orden no encontrada'));
      }

      return dartz.Right(hiveModel.toEntity());
    } catch (e) {
      return dartz.Left(LocalStorageFailure('Error al obtener la orden: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final hiveModel = _ordersBox.get(orderId);

      if (hiveModel == null) {
        return dartz.Left(LocalStorageFailure('Orden no encontrada'));
      }

      final updatedOrder = hiveModel.toEntity().copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      final updatedHiveModel = OrderHiveModel.fromEntity(updatedOrder);
      await _ordersBox.put(orderId, updatedHiveModel);

      return dartz.Right(updatedOrder);
    } catch (e) {
      return dartz.Left(LocalStorageFailure('Error al actualizar estado: $e'));
    }
  }

  @override
  Future<dartz.Either<Failure, void>> cancelOrder(String orderId) async {
    try {
      final hiveModel = _ordersBox.get(orderId);

      if (hiveModel == null) {
        return dartz.Left(LocalStorageFailure('Orden no encontrada'));
      }

      final order = hiveModel.toEntity();

      if (order.status == OrderStatus.cancelled ||
          order.status == OrderStatus.completed) {
        return dartz.Left(
          LocalStorageFailure(
            'No se puede cancelar una orden ${order.status.label}',
          ),
        );
      }

      final cancelledOrder = order.copyWith(
        status: OrderStatus.cancelled,
        updatedAt: DateTime.now(),
      );

      final cancelledHiveModel = OrderHiveModel.fromEntity(cancelledOrder);
      await _ordersBox.put(orderId, cancelledHiveModel);

      return const dartz.Right(null);
    } catch (e) {
      return dartz.Left(LocalStorageFailure('Error al cancelar orden: $e'));
    }
  }
}
