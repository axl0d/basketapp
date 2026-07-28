import 'package:hive/hive.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/orders/data/models/cart_item_hive_model.dart';
import 'package:basketapp/features/orders/data/models/order_status_hive_model.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: 2)
class OrderHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<CartItemHiveModel> items;

  @HiveField(2)
  final double totalPrice;

  @HiveField(3)
  final OrderStatusHiveModel status;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  OrderHiveModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Order toEntity() => Order(
    id: id,
    items: items.map((item) => item.toEntity()).toList(),
    totalPrice: totalPrice,
    status: status.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  factory OrderHiveModel.fromEntity(Order order) => OrderHiveModel(
    id: order.id,
    items: order.items.map((item) => CartItemHiveModel.fromEntity(item)).toList(),
    totalPrice: order.totalPrice,
    status: OrderStatusHiveModel.fromEntity(order.status),
    createdAt: order.createdAt,
    updatedAt: order.updatedAt,
  );
}
