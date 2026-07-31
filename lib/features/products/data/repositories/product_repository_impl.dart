import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/data/datasources/product_local_data_source.dart';
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ProductFailure('Error al cargar productos: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    try {
      final products = await remoteDataSource.getProducts();
      final filtered = products.where((p) => p.category == category).toList();
      return Right(filtered);
    } catch (e) {
      return Left(ProductFailure('Error al cargar productos por categoría: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await localDataSource.getProductFromCache(id);
      if (product == null) {
        return Left(ProductFailure('Producto no encontrado'));
      }
      return Right(product);
    } catch (e) {
      return Left(ProductFailure('Error al cargar producto: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> rateProduct(String productId, double rating) async {
    try {
      final updatedProduct = await localDataSource.updateProductRating(productId, rating);
      return Right(updatedProduct);
    } catch (e) {
      return Left(ProductFailure('Error al calificar producto: ${e.toString()}'));
    }
  }
}
