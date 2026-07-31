import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_method_selection.dart';
import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class CreateOrderEvent extends OrderEvent {
  final List<CartItem> items;
  final double totalPrice;
  final PaymentMethodSelection paymentMethod;

  const CreateOrderEvent(this.items, this.totalPrice, this.paymentMethod);

  @override
  List<Object?> get props => [items, totalPrice, paymentMethod];
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

class CreatedOrderSuccessfullyEvent extends OrderEvent {
  const CreatedOrderSuccessfullyEvent({required this.order});

  final Order order;

  @override
  List<Object?> get props => [order];
}
