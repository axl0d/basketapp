import 'package:basketapp/dumb/products.dart';
import 'package:basketapp/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<ProductModel>> getProducts() async {
    // Simula una llamada a un servicio con un retraso
    await Future.delayed(const Duration(seconds: 2));

    return mockProducts
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }
}
