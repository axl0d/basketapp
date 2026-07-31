import 'package:basketapp/core/notifications/notification_service.dart';
import 'package:basketapp/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_event.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final CancelOrderUseCase cancelOrderUseCase;
  final NotificationService notificationService;

  OrderBloc({
    required this.createOrderUseCase,
    required this.getOrderByIdUseCase,
    required this.updateOrderStatusUseCase,
    required this.cancelOrderUseCase,
    required this.notificationService,
  }) : super(const OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetOrderByIdEvent>(_onGetOrderById);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<CancelOrderEvent>(_onCancelOrder);
    on<CreatedOrderSuccessfullyEvent>(_onCreatedOrderSuccessfully);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    final result = await createOrderUseCase(event.items, event.totalPrice, event.paymentMethod);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => emit(OrderCreated(order)),
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

  void _onCreatedOrderSuccessfully(
    CreatedOrderSuccessfullyEvent event,
    Emitter<OrderState> emit,
  ) {
    notificationService.showLocalNotification(
      title: 'Tu pedido ha sido actualizado',
      body:
          'Orden ${event.order.id.substring(0, 8).toUpperCase()} ahora está: ${event.order.status.label}',
    );
  }
}
