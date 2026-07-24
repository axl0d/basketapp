import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];

  CartBloc() : super(const CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == event.product.id,
    );

    if (existingIndex >= 0) {
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + event.quantity,
      );
    } else {
      _cartItems.add(
        CartItem(
          productId: event.product.id,
          productName: event.product.name,
          price: event.product.price,
          quantity: event.quantity,
          imageUrl: event.product.imageUrl,
        ),
      );
    }

    _emitCartState(emit);
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    _cartItems.removeWhere((item) => item.productId == event.productId);
    _emitCartState(emit);
  }

  Future<void> _onClearCart(ClearCartEvent event, Emitter<CartState> emit) async {
    _cartItems.clear();
    _emitCartState(emit);
  }

  void _emitCartState(Emitter<CartState> emit) {
    final totalItems = _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);
    final totalPrice = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    emit(CartUpdated(
      items: List.unmodifiable(_cartItems),
      totalItems: totalItems,
      totalPrice: totalPrice,
    ));
  }
}
