# Guía: Agregar Nuevas Features

Esta guía te ayudará a agregar nuevas features siguiendo la arquitectura del proyecto.

## Estructura de una Feature

Cada feature sigue esta estructura:

```
features/[feature_name]/
├── data/
│   ├── datasources/
│   │   ├── [feature]_remote_data_source.dart
│   │   └── [feature]_local_data_source.dart      (opcional)
│   ├── models/
│   │   └── [model]_model.dart
│   └── repositories/
│       └── [feature]_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── [entity].dart
│   ├── repositories/
│   │   └── [feature]_repository.dart             (interfaz)
│   └── usecases/
│       ├── usecase1.dart
│       ├── usecase2.dart
│       └── usecase_n.dart
│
└── presentation/
    ├── bloc/
    │   ├── [feature]_bloc.dart
    │   ├── [feature]_event.dart
    │   └── [feature]_state.dart
    ├── pages/
    │   ├── [page1]_page.dart
    │   └── [page2]_page.dart
    └── widgets/
        ├── [widget1].dart
        └── [widget2].dart
```

## Ejemplo: Agregar Feature "Productos"

### Paso 1: Crear Entities (Domain Layer)

`lib/features/products/domain/entities/product.dart`:

```dart
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, stock];
}
```

### Paso 2: Crear Repository Abstrato

`lib/features/products/domain/repositories/product_repository.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
```

### Paso 3: Crear UseCases

`lib/features/products/domain/usecases/get_products_usecase.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getProducts();
  }
}
```

### Paso 4: Crear Models (Data Layer)

`lib/features/products/data/models/product_model.dart`:

```dart
import 'package:basketapp/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  factory ProductModel.fromFirebase(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }
}
```

### Paso 5: Crear Remote DataSource

`lib/features/products/data/datasources/product_remote_data_source.dart`:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:basketapp/core/errors/exceptions.dart';
import 'package:basketapp/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> searchProducts(String query);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await firestore.collection('products').get();
      return snapshot.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      throw ServerException('Error al obtener productos: $e');
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore.collection('products').doc(id).get();
      if (!doc.exists) {
        throw ServerException('Producto no encontrado');
      }
      return ProductModel.fromFirebase(doc);
    } catch (e) {
      throw ServerException('Error al obtener producto: $e');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final snapshot = await firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query')
          .get();
      return snapshot.docs.map((doc) => ProductModel.fromFirebase(doc)).toList();
    } catch (e) {
      throw ServerException('Error al buscar productos: $e');
    }
  }
}
```

### Paso 6: Crear Repository Implementation

`lib/features/products/data/repositories/product_repository_impl.dart`:

```dart
import 'package:dartz/dartz.dart';
import 'package:basketapp/core/errors/exceptions.dart';
import 'package:basketapp/core/errors/failure.dart';
import 'package:basketapp/features/products/data/datasources/product_remote_data_source.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }
}
```

### Paso 7: Crear BLoC Events

`lib/features/products/presentation/bloc/product_event.dart`:

```dart
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
  
  @override
  List<Object?> get props => [];
}

class GetProductsEvent extends ProductEvent {
  const GetProductsEvent();
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}
```

### Paso 8: Crear BLoC States

`lib/features/products/presentation/bloc/product_state.dart`:

```dart
import 'package:equatable/equatable.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
```

### Paso 9: Crear BLoC

`lib/features/products/presentation/bloc/product_bloc.dart`:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/products/domain/usecases/get_products_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase}) 
      : super(const ProductInitial()) {
    on<GetProductsEvent>(_onGetProducts);
  }

  Future<void> _onGetProducts(
    GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await getProductsUseCase();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
```

### Paso 10: Crear UI

`lib/features/products/presentation/pages/products_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/product_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/product_event.dart';
import 'package:basketapp/features/products/presentation/bloc/product_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price}'),
                );
              },
            );
          }
          
          if (state is ProductError) {
            return Center(child: Text(state.message));
          }
          
          return const SizedBox();
        },
      ),
    );
  }
}
```

### Paso 11: Registrar en Service Locator

En `lib/core/di/service_locator.dart`, agregar:

```dart
// DataSources
getIt.registerSingleton<ProductRemoteDataSource>(
  ProductRemoteDataSourceImpl(firestore),
);

// Repositories
getIt.registerSingleton<ProductRepository>(
  ProductRepositoryImpl(remoteDataSource: getIt<ProductRemoteDataSource>()),
);

// UseCases
getIt.registerSingleton<GetProductsUseCase>(
  GetProductsUseCase(getIt<ProductRepository>()),
);

// BLoCs
getIt.registerSingleton<ProductBloc>(
  ProductBloc(getProductsUseCase: getIt<GetProductsUseCase>()),
);
```

### Paso 12: Agregar Rutas

En `lib/routes.dart`:

```dart
static const String products = '/products';

static Map<String, WidgetBuilder> getRoutes() {
  return {
    // ... rutas existentes
    products: (context) => const ProductsPage(),
  };
}
```

## Checklist para Nuevas Features

- [ ] Crear entities en domain/
- [ ] Crear repository abstrato en domain/
- [ ] Crear usecases en domain/
- [ ] Crear models en data/
- [ ] Crear datasources en data/
- [ ] Crear repository implementation en data/
- [ ] Crear events en presentation/bloc/
- [ ] Crear states en presentation/bloc/
- [ ] Crear bloc en presentation/bloc/
- [ ] Crear pages en presentation/pages/
- [ ] Crear widgets en presentation/widgets/
- [ ] Registrar en service_locator.dart
- [ ] Agregar rutas en routes.dart
- [ ] Crear tests unitarios
- [ ] Probar en la aplicación

## Tips

1. **Mantén los layers separados**: No importes de presentation en domain
2. **Reutiliza widgets**: Crea componentes genéricos en presentation/widgets/
3. **Manejo de errores**: Siempre convierte excepciones en Failures
4. **Tests primero**: Escribe tests mientras desarrollas
5. **Nombra bien**: Usa convenciones claras (UserRepository, not getUser)

## Ejemplo Completo

Para un ejemplo completo funcional, consulta la feature de autenticación:
- `lib/features/auth/domain/`
- `lib/features/auth/data/`
- `lib/features/auth/presentation/`

Happy coding! 🚀
