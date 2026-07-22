import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/products_event.dart';
import 'package:basketapp/features/products/presentation/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc({required this.getProductsUseCase}) : super(const ProductsInitial()) {
    on<FetchProductsEvent>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    try {
      final products = await getProductsUseCase();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError('Error al cargar productos: ${e.toString()}'));
    }
  }
}
