import 'package:basketapp/core/di/service_locator.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';
import 'package:basketapp/features/payment_methods/domain/entities/payment_method_selection.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_bloc.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_event.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_state.dart';
import 'package:basketapp/features/payment_methods/presentation/screens/add_card_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodSelectionScreen extends StatefulWidget {
  final double totalPrice;

  const PaymentMethodSelectionScreen({super.key, required this.totalPrice});

  @override
  State<PaymentMethodSelectionScreen> createState() =>
      _PaymentMethodSelectionScreenState();
}

class _PaymentMethodSelectionScreenState
    extends State<PaymentMethodSelectionScreen> {
  late PaymentMethodBloc _bloc;
  PaymentMethodSelection? _selected;

  @override
  void initState() {
    super.initState();
    _bloc = getIt<PaymentMethodBloc>();
    _bloc.add(const GetSavedCardsEvent());
  }

  void _selectCash() {
    setState(() {
      _selected = const PaymentMethodSelection(type: PaymentMethodType.cash);
    });
  }

  void _selectCard(PaymentCard card) {
    setState(() {
      _selected = PaymentMethodSelection(
        type: PaymentMethodType.card,
        card: card,
      );
    });
  }

  Future<void> _navigateToAddCard() async {
    final result = await Navigator.push<PaymentCard>(
      context,
      MaterialPageRoute(builder: (_) => AddCardScreen(bloc: _bloc)),
    );

    if (result != null) {
      _bloc.add(const GetSavedCardsEvent());
      _selectCard(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Método de Pago'),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCashOption(),
                    const SizedBox(height: 16),
                    if (state is PaymentMethodCardsLoaded)
                      ...state.cards.map((card) => _buildCardOption(card)),
                    if (state is PaymentMethodCardsLoaded &&
                        state.cards.isNotEmpty)
                      const SizedBox(height: 16),
                    _buildAddCardOption(),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${widget.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selected == null
                            ? null
                            : () => Navigator.pop(context, _selected),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: const Text(
                          'Procesar Compra',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      },
    );
  }

  Widget _buildCashOption() {
    final isSelected = _selected?.type == PaymentMethodType.cash;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.deepPurple.withValues(alpha: 0.05) : null,
      ),
      child: ListTile(
        leading: Icon(
          Icons.money,
          color: isSelected ? Colors.deepPurple : Colors.grey[600],
        ),
        title: const Text('Pagar en Efectivo'),
        trailing: Checkbox(value: isSelected, onChanged: (_) => _selectCash()),
        onTap: _selectCash,
      ),
    );
  }

  Widget _buildCardOption(PaymentCard card) {
    final isSelected = _selected?.card?.id == card.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.deepPurple : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isSelected ? Colors.deepPurple.withValues(alpha: 0.05) : null,
      ),
      child: ListTile(
        leading: Icon(
          _getCardIcon(card.brand),
          color: isSelected ? Colors.deepPurple : Colors.grey[600],
        ),
        title: Text(card.cardholderName),
        subtitle: Text(
          '${card.maskedNumber} • ${card.expiryMonth}/${card.expiryYear}',
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (_) => _selectCard(card),
        ),
        onTap: () => _selectCard(card),
      ),
    );
  }

  Widget _buildAddCardOption() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
        title: const Text('Agregar Nueva Tarjeta'),
        onTap: _navigateToAddCard,
      ),
    );
  }

  IconData _getCardIcon(CardBrand brand) {
    switch (brand) {
      case CardBrand.visa:
        return Icons.star;
      case CardBrand.mastercard:
        return Icons.face;
      case CardBrand.amex:
        return Icons.credit_card;
      case CardBrand.other:
        return Icons.card_giftcard;
    }
  }
}
