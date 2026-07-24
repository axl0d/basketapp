import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> rateProduct(String productId, double rating);
}
