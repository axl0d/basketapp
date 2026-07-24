import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';

class RateProductUseCase {
  final ProductRepository repository;

  RateProductUseCase(this.repository);

  Future<Either<Failure, Product>> call(String productId, double rating) async {
    if (rating < 1 || rating > 5) {
      return Left(ValidationFailure('Rating debe estar entre 1 y 5'));
    }
    return await repository.rateProduct(productId, rating);
  }
}
