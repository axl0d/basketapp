import 'package:dartz/dartz.dart' as dartz;
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_method_selection.dart';

abstract class OrderRepository {
  Future<dartz.Either<Failure, Order>> createOrder(List<CartItem> items, double totalPrice, PaymentMethodSelection paymentMethod);
  Future<dartz.Either<Failure, List<Order>>> getOrders();
  Future<dartz.Either<Failure, Order>> getOrderById(String orderId);
  Future<dartz.Either<Failure, Order>> updateOrderStatus(String orderId, OrderStatus status);
  Future<dartz.Either<Failure, void>> cancelOrder(String orderId);
}
