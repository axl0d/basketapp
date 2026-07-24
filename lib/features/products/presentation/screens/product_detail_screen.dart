import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:basketapp/features/products/domain/entities/product.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_event.dart';
import 'package:basketapp/features/products/presentation/bloc/product_detail_state.dart';
import 'package:basketapp/features/products/presentation/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductDetailBloc _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _productDetailBloc = getIt<ProductDetailBloc>();
    _productDetailBloc.add(FetchProductByIdEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Producto'), elevation: 0),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        bloc: _productDetailBloc,
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductDetailLoaded) {
            return ProductDetailView(product: state.product);
          }

          if (state is ProductDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _productDetailBloc.add(
                        FetchProductByIdEvent(widget.productId),
                      );
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Estado desconocido'));
        },
      ),
    );
  }
}

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  late ProductDetailBloc _productDetailBloc;

  @override
  void initState() {
    super.initState();
    _productDetailBloc = getIt<ProductDetailBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Container(
            width: double.infinity,
            height: 300,
            color: Colors.grey[200],
            child: Image.network(
              widget.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),
          // Contenido
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  widget.product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Categoría
                Chip(
                  label: Text(widget.product.category),
                  backgroundColor: Colors.deepPurple.withOpacity(0.2),
                  labelStyle: const TextStyle(color: Colors.deepPurple),
                ),
                const SizedBox(height: 16),
                // Precio
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Stock
                Row(
                  children: [
                    Text(
                      'Stock disponible: ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${widget.product.stock} unidades',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: widget.product.stock > 0
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Rating y estrellas
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calificación',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        RatingStars(
                          rating: widget.product.rating,
                          starSize: 24,
                          onRatingChanged: (newRating) {
                            _productDetailBloc.add(
                              RateProductEvent(widget.product.id, newRating),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${widget.product.rating.toStringAsFixed(1)}/5.0',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Descripción
                Text(
                  'Descripción',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                // Botón agregar al carrito
                SizedBox(
                  width: double.infinity,
                  child: BlocListener<CartBloc, dynamic>(
                    listener: (context, state) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✓ ${widget.product.name} agregado al carrito',
                          ),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: ElevatedButton(
                      onPressed: widget.product.stock > 0
                          ? () {
                              context.read<CartBloc>().add(
                                AddToCartEvent(widget.product),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        disabledBackgroundColor: Colors.grey[400],
                      ),
                      child: Text(
                        widget.product.stock > 0
                            ? 'Agregar al Carrito'
                            : 'Sin Stock',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
