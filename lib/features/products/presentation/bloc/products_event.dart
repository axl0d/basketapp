import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsEvent extends ProductsEvent {
  const FetchProductsEvent();
}

class SaveLoadedProductsEvent extends ProductsEvent {
  const SaveLoadedProductsEvent(this.products);

  final List<Product> products;
}
