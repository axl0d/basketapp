import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, CartItem>> call(CartItem item) {
    return repository.addToCart(item);
  }
}
