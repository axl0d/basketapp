import 'package:equatable/equatable.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCartEvent(this.product, {this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateQuantityEvent(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId, quantity];
}

class GetCartItemsEvent extends CartEvent {
  const GetCartItemsEvent();
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
