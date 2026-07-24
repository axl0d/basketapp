import 'package:basketapp/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/rate_product_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_event.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUseCase getProductByIdUseCase;
  final RateProductUseCase rateProductUseCase;

  ProductDetailBloc({
    required this.getProductByIdUseCase,
    required this.rateProductUseCase,
  }) : super(const ProductDetailInitial()) {
    on<FetchProductByIdEvent>(_onFetchProductById);
    on<RateProductEvent>(_onRateProduct);
  }

  Future<void> _onFetchProductById(
    FetchProductByIdEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());
    final result = await getProductByIdUseCase(event.productId);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }

  Future<void> _onRateProduct(
    RateProductEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(ProductDetailLoaded(currentState.product));
    }

    final result = await rateProductUseCase(event.productId, event.rating);
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (updatedProduct) => emit(ProductDetailLoaded(updatedProduct)),
    );
  }
}
