import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_bloc.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_event.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_state.dart';
import 'package:basketapp/features/orders/presentation/screens/order_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/bloc/notification_bloc.dart';
import '../../../../core/notifications/bloc/notification_state.dart';
import '../../domain/entities/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrderListBloc _orderListBloc;

  @override
  void initState() {
    super.initState();
    _orderListBloc = getIt<OrderListBloc>();
    _orderListBloc.add(const FetchOrderListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Órdenes'), elevation: 0),
      body: BlocBuilder<OrderListBloc, OrderListState>(
        bloc: _orderListBloc,
        builder: (context, state) {
          if (state is OrderListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (state is OrderListEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes órdenes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completa tu primera compra',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (state is OrderListLoaded) {
            return OrdersList(state.orders);
          }

          return const Center(child: Text('Estado desconocido'));
        },
      ),
    );
  }
}

class OrdersList extends StatefulWidget {
  const OrdersList(this.orders, {super.key});

  final List<Order> orders;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  late OrderListBloc _orderListBloc;

  @override
  void initState() {
    super.initState();
    _orderListBloc = getIt<OrderListBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationReceived) {
          _orderListBloc.add(
            UpdateOrderListEvent(
              orderId: state.orderId,
              orderStatus: state.orderStatus,
            ),
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          _orderListBloc.add(const RefreshOrderListEvent());
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: widget.orders.length,
          itemBuilder: (context, index) {
            final order = widget.orders[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailScreen(orderId: order.id),
                    ),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.deepPurple,
                  ),
                ),
                title: Text(
                  'Orden #${order.orderId}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '${order.items.length} producto(s)',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: \$${order.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text(order.status.label),
                  backgroundColor: _getStatusColor(order.status),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status.toString()) {
      case 'OrderStatus.pending':
        return Colors.orange;
      case 'OrderStatus.processing':
        return Colors.blue;
      case 'OrderStatus.completed':
        return Colors.green;
      case 'OrderStatus.cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
