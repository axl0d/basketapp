import 'package:basketapp/core/notifications/bloc/notification_bloc.dart';
import 'package:basketapp/core/notifications/notification_service.dart';
import 'package:basketapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:basketapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:basketapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:basketapp/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:basketapp/features/auth/domain/usecases/register_usecase.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:basketapp/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:basketapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:basketapp/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:basketapp/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:basketapp/features/orders/data/repositories/order_repository_hive.dart';
import 'package:basketapp/features/orders/domain/repositories/order_repository.dart';
import 'package:basketapp/features/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:basketapp/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_bloc.dart';
import 'package:basketapp/features/orders/presentation/bloc/order_list_bloc.dart';
import 'package:basketapp/features/payment_methods/data/repositories/payment_method_repository_hive.dart';
import 'package:basketapp/features/payment_methods/domain/repositories/payment_method_repository.dart';
import 'package:basketapp/features/payment_methods/domain/usecases/add_payment_card_usecase.dart';
import 'package:basketapp/features/payment_methods/domain/usecases/get_saved_cards_usecase.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_bloc.dart';
import 'package:basketapp/features/products/data/datasources/product_local_data_source.dart';
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';
import 'package:basketapp/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/rate_product_usecase.dart';
import 'package:basketapp/features/products/domain/usecases/save_products_usecase.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/products_bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // HTTP Client
  final dio = Dio();
  getIt.registerSingleton<Dio>(dio);

  // Firebase
  final firebaseAuth = firebase_auth.FirebaseAuth.instance;
  getIt.registerSingleton<firebase_auth.FirebaseAuth>(firebaseAuth);

  // Notifications
  final fcm = FirebaseMessaging.instance;
  getIt.registerSingleton<FirebaseMessaging>(fcm);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
    flutterLocalNotificationsPlugin,
  );

  // Notifications
  getIt.registerSingleton<NotificationService>(
    NotificationService(
      getIt<FirebaseMessaging>(),
      getIt<FlutterLocalNotificationsPlugin>(),
    ),
  );

  // Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(getIt<firebase_auth.FirebaseAuth>()),
  );
  getIt.registerSingleton<ProductRemoteDataSource>(
    ProductRemoteDataSourceImpl(dio: getIt<Dio>()),
  );
  getIt.registerSingleton<ProductLocalDataSource>(ProductLocalDataSourceImpl());

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
  getIt.registerSingleton<CartRepository>(CartRepositoryImpl());
  getIt.registerSingleton<PaymentMethodRepository>(
    PaymentMethodRepositoryHive(),
  );
  getIt.registerSingleton<OrderRepository>(OrderRepositoryHive());

  // Use Cases
  getIt.registerSingleton<LoginUseCase>(LoginUseCase(getIt<AuthRepository>()));
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
  getIt.registerSingleton<SaveProductsUseCase>(
    SaveProductsUseCase(getIt<ProductRepository>()),
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
  getIt.registerSingleton<GetSavedCardsUseCase>(
    GetSavedCardsUseCase(getIt<PaymentMethodRepository>()),
  );
  getIt.registerSingleton<AddPaymentCardUseCase>(
    AddPaymentCardUseCase(getIt<PaymentMethodRepository>()),
  );
  getIt.registerSingleton<CreateOrderUseCase>(
    CreateOrderUseCase(getIt<OrderRepository>()),
  );
  getIt.registerSingleton<GetOrdersUseCase>(
    GetOrdersUseCase(getIt<OrderRepository>()),
  );
  getIt.registerSingleton<GetOrderByIdUseCase>(
    GetOrderByIdUseCase(getIt<OrderRepository>()),
  );
  getIt.registerSingleton<UpdateOrderStatusUseCase>(
    UpdateOrderStatusUseCase(getIt<OrderRepository>()),
  );
  getIt.registerSingleton<CancelOrderUseCase>(
    CancelOrderUseCase(getIt<OrderRepository>()),
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
      saveProductsUseCase: getIt<SaveProductsUseCase>(),
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
  getIt.registerSingleton<PaymentMethodBloc>(
    PaymentMethodBloc(
      getSavedCardsUseCase: getIt<GetSavedCardsUseCase>(),
      addPaymentCardUseCase: getIt<AddPaymentCardUseCase>(),
    ),
  );
  getIt.registerSingleton<OrderBloc>(
    OrderBloc(
      createOrderUseCase: getIt<CreateOrderUseCase>(),
      getOrderByIdUseCase: getIt<GetOrderByIdUseCase>(),
      updateOrderStatusUseCase: getIt<UpdateOrderStatusUseCase>(),
      cancelOrderUseCase: getIt<CancelOrderUseCase>(),
      notificationService: getIt<NotificationService>(),
    ),
  );
  getIt.registerSingleton<OrderListBloc>(
    OrderListBloc(getOrdersUseCase: getIt<GetOrdersUseCase>()),
  );
  getIt.registerSingleton<NotificationBloc>(
    NotificationBloc(notificationService: getIt<NotificationService>()),
  );
}
