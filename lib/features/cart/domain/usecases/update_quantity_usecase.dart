import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository repository;

  UpdateQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(String productId, int quantity) {
    return repository.updateQuantity(productId, quantity);
  }
}
