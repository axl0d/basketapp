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
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';
import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/products_bloc.dart';

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
    ),
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
}
