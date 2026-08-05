import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/save_products_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/products_event.dart';
import 'package:basketapp/features/products/presentation/bloc/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({
    required this.getProductsUseCase,
    required this.saveProductsUseCase,
  }) : super(const ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
    on<SaveLoadedProductsEvent>(_onSaveProducts);
  }

  final GetProductsUseCase getProductsUseCase;
  final SaveProductsUseCase saveProductsUseCase;

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  Future<void> _onSaveProducts(
    SaveLoadedProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    saveProductsUseCase(event.products);
  }
}
