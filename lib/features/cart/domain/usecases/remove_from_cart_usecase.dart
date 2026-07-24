import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId) {
    return repository.removeFromCart(productId);
  }
}
