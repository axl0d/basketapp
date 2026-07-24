import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:basketapp/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;
  final GetCartItemsUseCase getCartItemsUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required this.getCartItemsUseCase,
    required this.clearCartUseCase,
  }) : super(const CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<GetCartItemsEvent>(_onGetCartItems);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    final cartItem = CartItem(
      productId: event.product.id,
      productName: event.product.name,
      price: event.product.price,
      quantity: event.quantity,
      imageUrl: event.product.imageUrl,
    );

    final result = await addToCartUseCase(cartItem);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const GetCartItemsEvent()),
    );
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    final result = await removeFromCartUseCase(event.productId);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const GetCartItemsEvent()),
    );
  }

  Future<void> _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    final result = await clearCartUseCase();
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => emit(const CartUpdated(items: [], totalItems: 0, totalPrice: 0)),
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    final result = await updateQuantityUseCase(event.productId, event.quantity);
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (_) => add(const GetCartItemsEvent()),
    );
  }

  Future<void> _onGetCartItems(
    GetCartItemsEvent event,
    Emitter<CartState> emit,
  ) async {
    final result = await getCartItemsUseCase();
    result.fold((failure) => emit(CartError(failure.message)), (items) {
      final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
      final totalPrice = items.fold<double>(
        0,
        (sum, item) => sum + (item.price * item.quantity),
      );

      emit(
        CartUpdated(
          items: items,
          totalItems: totalItems,
          totalPrice: totalPrice,
        ),
      );
    });
  }
}
