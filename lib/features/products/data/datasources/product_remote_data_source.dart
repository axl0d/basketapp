import 'dart:convert';

import 'package:basketapp/features/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

const String url =
    'https://raw.githubusercontent.com/axl0d/basketapp/main/contents/products.json';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get(url);
      final jsonData = jsonDecode(response.data) as List<dynamic>;
      if (response.statusCode == 200) {
        return jsonData
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching products: ${e.message}');
    }
  }
}
