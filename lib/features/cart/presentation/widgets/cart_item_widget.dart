import 'package:basketapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: Image.network(
                  widget.item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.productName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: _quantity > 1
                          ? () {
                              setState(() => _quantity--);
                              widget.onQuantityChanged(_quantity);
                            }
                          : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _quantity.toString(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    IconButton(
                      iconSize: 20,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() => _quantity++);
                        widget.onQuantityChanged(_quantity);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Subtotal: \$${(widget.item.price * _quantity).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                IconButton(
                  iconSize: 20,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
