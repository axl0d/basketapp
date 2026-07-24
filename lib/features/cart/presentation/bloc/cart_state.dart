import 'package:equatable/equatable.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartUpdated extends CartState {
  final List<CartItem> items;
  final int totalItems;
  final double totalPrice;

  const CartUpdated({
    required this.items,
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [items, totalItems, totalPrice];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
