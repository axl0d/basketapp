import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_event.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrderListBloc({required this.getOrdersUseCase})
      : super(const OrderListInitial()) {
    on<FetchOrderListEvent>(_onFetchOrderList);
    on<RefreshOrderListEvent>(_onRefreshOrderList);
  }

  Future<void> _onFetchOrderList(
    FetchOrderListEvent event,
    Emitter<OrderListState> emit,
  ) async {
    emit(const OrderListLoading());
    final result = await getOrdersUseCase();
    result.fold(
      (failure) => emit(OrderListError(failure.message)),
      (orders) {
        if (orders.isEmpty) {
          emit(const OrderListEmpty());
        } else {
          emit(OrderListLoaded(orders));
        }
      },
    );
  }

  Future<void> _onRefreshOrderList(
    RefreshOrderListEvent event,
    Emitter<OrderListState> emit,
  ) async {
    final result = await getOrdersUseCase();
    result.fold(
      (failure) => emit(OrderListError(failure.message)),
      (orders) {
        if (orders.isEmpty) {
          emit(const OrderListEmpty());
        } else {
          emit(OrderListLoaded(orders));
        }
      },
    );
  }
}
