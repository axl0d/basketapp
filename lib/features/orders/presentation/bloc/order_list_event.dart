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
