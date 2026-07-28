import 'package:equatable/equatable.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';

enum OrderStatus {
  pending('Pendiente'),
  processing('En proceso'),
  completed('Completado'),
  cancelled('Cancelado');

  final String label;
  const OrderStatus(this.label);
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? totalPrice,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, items, totalPrice, status, createdAt, updatedAt];
}
