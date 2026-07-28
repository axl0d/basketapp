import 'package:hive/hive.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';

part 'cart_item_hive_model.g.dart';

@HiveType(typeId: 1)
class CartItemHiveModel {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final String imageUrl;

  CartItemHiveModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartItem toEntity() => CartItem(
    productId: productId,
    productName: productName,
    price: price,
    quantity: quantity,
    imageUrl: imageUrl,
  );

  factory CartItemHiveModel.fromEntity(CartItem item) => CartItemHiveModel(
    productId: item.productId,
    productName: item.productName,
    price: item.price,
    quantity: item.quantity,
    imageUrl: item.imageUrl,
  );
}
