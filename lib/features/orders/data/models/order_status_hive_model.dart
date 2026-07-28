import 'package:hive/hive.dart';
import 'package:basketapp/features/orders/domain/entities/order.dart';

part 'order_status_hive_model.g.dart';

@HiveType(typeId: 0)
class OrderStatusHiveModel {
  @HiveField(0)
  final int statusIndex;

  OrderStatusHiveModel({required this.statusIndex});

  OrderStatus toEntity() => OrderStatus.values[statusIndex];

  factory OrderStatusHiveModel.fromEntity(OrderStatus status) {
    return OrderStatusHiveModel(statusIndex: status.index);
  }
}
