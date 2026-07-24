import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductByIdEvent extends ProductDetailEvent {
  final String productId;

  const FetchProductByIdEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class RateProductEvent extends ProductDetailEvent {
  final String productId;
  final double rating;

  const RateProductEvent(this.productId, this.rating);

  @override
  List<Object?> get props => [productId, rating];
}
