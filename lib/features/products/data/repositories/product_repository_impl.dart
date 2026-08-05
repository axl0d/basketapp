import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/data/datasources/product_local_data_source.dart';
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/data/models/product_model.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } catch (e) {
      return Left(ProductFailure('Error al cargar productos: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final products = await remoteDataSource.getProducts();
      final filtered = products.where((p) => p.category == category).toList();
      return Right(filtered);
    } catch (e) {
      return Left(
        ProductFailure(
          'Error al cargar productos por categoría: $e',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await localDataSource.getProductFromCache(id);
      if (product == null) {
        return const Left(ProductFailure('Producto no encontrado'));
      }
      return Right(product);
    } catch (e) {
      return Left(ProductFailure('Error al cargar producto: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> rateProduct(
    String productId,
    double rating,
  ) async {
    try {
      final updatedProduct = await localDataSource.updateProductRating(
        productId,
        rating,
      );
      return Right(updatedProduct);
    } catch (e) {
      return Left(
        ProductFailure('Error al calificar producto: $e'),
      );
    }
  }

  @override
  Either<Failure, void> saveProductsToCache(List<Product> products) {
    try {
      final productModels = products
          .map((product) => product.toModel())
          .toList();
      localDataSource.saveProductsToCache(productModels);
      return const Right(null);
    } catch (e) {
      return Left(
        ProductFailure('Error al calificar producto: $e'),
      );
    }
  }
}
