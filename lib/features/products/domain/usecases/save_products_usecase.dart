import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';

class SaveProductsUseCase {
  const SaveProductsUseCase(this.repository);

  final ProductRepository repository;

  void call(List<Product> products) {
    repository.saveProductsToCache(products);
  }
}
