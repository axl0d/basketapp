import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:basketapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:basketapp/features/cart/presentation/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      bloc: getIt<CartBloc>(),
      builder: (context, state) {
        int itemCount = 0;
        if (state is CartUpdated) {
          itemCount = state.totalItems;
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
            if (itemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      itemCount > 99 ? '99+' : itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
