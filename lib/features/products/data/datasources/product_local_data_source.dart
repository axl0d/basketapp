import 'package:basketapp/dumb/products.dart';
import 'package:basketapp/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel> updateProductRating(String productId, double rating);
  Future<ProductModel?> getProductFromCache(String productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Map<String, ProductModel> _productCache = {};

  Future<void> _loadProductsToCache() async {
    if (_productCache.isEmpty) {
      for (final json in mockProducts) {
        final product = ProductModel.fromJson(json);
        _productCache[product.id] = product;
      }
    }
  }

  @override
  Future<ProductModel> updateProductRating(String productId, double rating) async {
    await _loadProductsToCache();

    final product = _productCache[productId];
    if (product == null) {
      throw Exception('Producto no encontrado');
    }

    final newRating = (product.rating + rating) / 2;
    final updatedProduct = ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      category: product.category,
      stock: product.stock,
      rating: newRating,
    );

    _productCache[productId] = updatedProduct;
    return updatedProduct;
  }

  @override
  Future<ProductModel?> getProductFromCache(String productId) async {
    await _loadProductsToCache();
    return _productCache[productId];
  }
}
