import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:get_it/get_it.dart';
import 'package:basketapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:basketapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:basketapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:basketapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:basketapp/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:basketapp/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/data/datasources/product_local_data_source.dart';
import 'package:basketapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';
import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/rate_product_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/products_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Firebase
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  getIt.registerSingleton<firebase_auth.FirebaseAuth>(firebaseAuth);

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(getIt<firebase_auth.FirebaseAuth>()),
  );
  getIt.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(),
  );
  getIt.registerSingleton<ProductLocalDataSource>(
    ProductLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      firebaseAuth: getIt<firebase_auth.FirebaseAuth>(),
    ),
  );
  getIt.registerSingleton<ProductRepository>(
    ProductRepositoryImpl(
      remoteDataSource: getIt<ProductRemoteDataSource>(),
      localDataSource: getIt<ProductLocalDataSource>(),
    ),
  );
  getIt.registerSingleton<CartRepository>(
    CartRepositoryImpl(),
  );

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(
    LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<RegisterUseCase>(
    RegisterUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUseCase>(
    LogoutUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetCurrentUserUseCase>(
    GetCurrentUserUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetProductsUseCase>(
    GetProductsUseCase(getIt<ProductRepository>()),
  );
  getIt.registerSingleton<GetProductByIdUseCase>(
    GetProductByIdUseCase(getIt<ProductRepository>()),
  );
  getIt.registerSingleton<RateProductUseCase>(
    RateProductUseCase(getIt<ProductRepository>()),
  );
  getIt.registerSingleton<AddToCartUseCase>(
    AddToCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerSingleton<RemoveFromCartUseCase>(
    RemoveFromCartUseCase(getIt<CartRepository>()),
  );
  getIt.registerSingleton<UpdateQuantityUseCase>(
    UpdateQuantityUseCase(getIt<CartRepository>()),
  );
  getIt.registerSingleton<GetCartItemsUseCase>(
    GetCartItemsUseCase(getIt<CartRepository>()),
  );
  getIt.registerSingleton<ClearCartUseCase>(
    ClearCartUseCase(getIt<CartRepository>()),
  );

  // BLoCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      getCurrentUserUseCase: getIt<GetCurrentUserUseCase>(),
    ),
  );
  getIt.registerSingleton<ProductsBloc>(
    ProductsBloc(
      getProductsUseCase: getIt<GetProductsUseCase>(),
    ),
  );
  getIt.registerSingleton<ProductDetailBloc>(
    ProductDetailBloc(
      getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
      rateProductUseCase: getIt<RateProductUseCase>(),
    ),
  );
  getIt.registerSingleton<CartBloc>(
    CartBloc(
      addToCartUseCase: getIt<AddToCartUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      updateQuantityUseCase: getIt<UpdateQuantityUseCase>(),
      getCartItemsUseCase: getIt<GetCartItemsUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );
}
