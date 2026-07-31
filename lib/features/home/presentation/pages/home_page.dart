import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:basketapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:basketapp/features/cart/presentation/widgets/cart_badge.dart';
import 'package:basketapp/features/orders/presentation/screens/orders_screen.dart';
import 'package:basketapp/features/products/presentation/bloc/products_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/products_event.dart';
import 'package:basketapp/features/products/presentation/bloc/products_state.dart';
import 'package:basketapp/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    _productsBloc = getIt<ProductsBloc>();
    _productsBloc.add(const FetchProductsEvent());
  }

  @override
  void dispose() {
    _productsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tienda'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrdersScreen()),
              );
            },
          ),
          const CartBadgeIcon(),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthAuthenticated) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Bienvenido ${authState.user.displayName ?? authState.user.email}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                Expanded(
                  child: BlocProvider.value(
                    value: _productsBloc,
                    child: BlocBuilder<ProductsBloc, ProductsState>(
                      builder: (context, productsState) {
                        if (productsState is ProductsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (productsState is ProductsLoaded) {
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: productsState.products.length,
                            itemBuilder: (context, index) {
                              final product = productsState.products[index];
                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/product',
                                    arguments: product.id,
                                  );
                                },
                              );
                            },
                          );
                        } else if (productsState is ProductsError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  productsState.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    _productsBloc.add(
                                      const FetchProductsEvent(),
                                    );
                                  },
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(child: Text('Sin productos'));
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutEvent());
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Cerrar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
