import 'package:basketapp/features/orders/data/models/cart_item_hive_model.dart';
import 'package:basketapp/features/orders/data/models/order_status_hive_model.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_method_selection.dart';
import 'package:hive/hive.dart';

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

  @HiveField(6)
  final int? paymentMethodTypeIndex;

  @HiveField(7)
  final String? cardLast4;

  @HiveField(8)
  final String? cardBrand;

  OrderHiveModel({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethodTypeIndex,
    this.cardLast4,
    this.cardBrand,
  });

  Order toEntity() => Order(
    id: id,
    items: items.map((item) => item.toEntity()).toList(),
    totalPrice: totalPrice,
    status: status.toEntity(),
    createdAt: createdAt,
    updatedAt: updatedAt,
    paymentMethodType: PaymentMethodType.values[paymentMethodTypeIndex ?? 0],
    cardLast4: cardLast4,
    cardBrand: cardBrand,
  );

  factory OrderHiveModel.fromEntity(Order order) => OrderHiveModel(
    id: order.id,
    items: order.items
        .map((item) => CartItemHiveModel.fromEntity(item))
        .toList(),
    totalPrice: order.totalPrice,
    status: OrderStatusHiveModel.fromEntity(order.status),
    createdAt: order.createdAt,
    updatedAt: order.updatedAt,
    paymentMethodTypeIndex: order.paymentMethodType.index,
    cardLast4: order.cardLast4,
    cardBrand: order.cardBrand,
  );
}
