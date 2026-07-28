import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_event.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  OrderBloc({
    required this.createOrderUseCase,
    required this.getOrdersUseCase,
    required this.getOrderByIdUseCase,
    required this.updateOrderStatusUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrdersEvent>(_onGetOrders);
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<CancelOrderEvent>(_onCancelOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await createOrderUseCase(event.items, event.totalPrice);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderCreated(order)),
    );
  }

  Future<void> _onGetOrders(
    GetOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await getOrdersUseCase();
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onGetOrderById(
    GetOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await getOrderByIdUseCase(event.orderId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderDetailLoaded(order)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await updateOrderStatusUseCase(event.orderId, event.status);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderStatusUpdated(order)),
    );
  }

  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await cancelOrderUseCase(event.orderId);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (_) => emit(OrderCancelled(event.orderId)),
    );
  }
}
