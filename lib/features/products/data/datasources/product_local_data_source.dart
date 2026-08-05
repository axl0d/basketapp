import 'package:basketapp/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel> updateProductRating(String productId, double rating);

  Future<ProductModel?> getProductFromCache(String productId);

  void saveProductsToCache(List<ProductModel> products);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Map<String, ProductModel> _productCache = {};

  @override
  Future<ProductModel> updateProductRating(
    String productId,
    double rating,
  ) async {
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
  Future<void> saveProductsToCache(List<ProductModel> products) async {
    for (final product in products) {
      _productCache[product.id] = product;
    }
  }

  @override
  Future<ProductModel?> getProductFromCache(String productId) async {
    return _productCache[productId];
  }
}
