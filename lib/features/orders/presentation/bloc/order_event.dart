import 'package:equatable/equatable.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrderEvent {
  final List<CartItem> items;
  final double totalPrice;

  const CreateOrderEvent(this.items, this.totalPrice);

  @override
  List<Object?> get props => [items, totalPrice];
}

class GetOrderByIdEvent extends OrderEvent {
  final String orderId;

  const GetOrderByIdEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatusEvent(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}

class CancelOrderEvent extends OrderEvent {
  final String orderId;

  const CancelOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
