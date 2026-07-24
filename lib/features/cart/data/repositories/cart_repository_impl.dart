import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl extends CartRepository {
  final List<CartItem> _cartItems = [];

  @override
  Future<Either<Failure, CartItem>> addToCart(CartItem item) async {
    try {
      final existingIndex = _cartItems.indexWhere(
        (cartItem) => cartItem.productId == item.productId,
      );

      if (existingIndex >= 0) {
        final existingItem = _cartItems[existingIndex];
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
        _cartItems[existingIndex] = updatedItem;
        return Right(updatedItem);
      } else {
        _cartItems.add(item);
        return Right(item);
      }
    } catch (e) {
      return Left(ServerFailure('Error al agregar al carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      _cartItems.removeWhere((item) => item.productId == productId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al remover del carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final index = _cartItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (index >= 0) {
        if (quantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          final item = _cartItems[index];
          _cartItems[index] = item.copyWith(quantity: quantity);
        }
        return const Right(null);
      }

      return Left(ServerFailure('Producto no encontrado en el carrito'));
    } catch (e) {
      return Left(ServerFailure('Error al actualizar cantidad: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      return Right(List.unmodifiable(_cartItems));
    } catch (e) {
      return Left(ServerFailure('Error al obtener items del carrito: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      _cartItems.clear();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Error al vaciar carrito: $e'));
    }
  }
}
