import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartRepository {
  Future<Either<Failure, CartItem>> addToCart(CartItem item);
  Future<Either<Failure, void>> removeFromCart(String productId);
  Future<Either<Failure, void>> updateQuantity(String productId, int quantity);
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> clearCart();
}
