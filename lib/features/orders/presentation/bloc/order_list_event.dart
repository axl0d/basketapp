import 'package:equatable/equatable.dart';

abstract class OrderListEvent extends Equatable {
  const OrderListEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderListEvent extends OrderListEvent {
  const FetchOrderListEvent();
}

class RefreshOrderListEvent extends OrderListEvent {
  const RefreshOrderListEvent();
}

class UpdateOrderListEvent extends OrderListEvent {
  const UpdateOrderListEvent({
    required this.orderId,
    required this.orderStatus,
  });

  final String orderId;
  final String orderStatus;

  @override
  List<Object?> get props => [orderId, orderStatus];
}
