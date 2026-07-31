import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_method_selection.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending('Pendiente'),
  processing('En proceso'),
  completed('Completado'),
  cancelled('Cancelado');

  final String label;

  const OrderStatus(this.label);
}

OrderStatus fromNotificationToOrderStatus(String status) {
  switch (status) {
    case 'Pendiente':
      return OrderStatus.pending;
    case 'En proceso':
      return OrderStatus.processing;
    case 'Completado':
      return OrderStatus.completed;
    case 'Cancelado':
    default:
      return OrderStatus.cancelled;
  }
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalPrice;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentMethodType paymentMethodType;
  final String? cardLast4;
  final String? cardBrand;

  const Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.paymentMethodType,
    this.cardLast4,
    this.cardBrand,
  });

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? totalPrice,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    PaymentMethodType? paymentMethodType,
    String? cardLast4,
    String? cardBrand,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentMethodType: paymentMethodType ?? this.paymentMethodType,
      cardLast4: cardLast4 ?? this.cardLast4,
      cardBrand: cardBrand ?? this.cardBrand,
    );
  }

  String get orderId => id.substring(id.length - 4);

  @override
  List<Object?> get props => [
    id,
    items,
    totalPrice,
    status,
    createdAt,
    updatedAt,
    paymentMethodType,
    cardLast4,
    cardBrand,
  ];
}
