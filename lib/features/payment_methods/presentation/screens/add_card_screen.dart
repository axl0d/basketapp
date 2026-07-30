import 'package:basketapp/features/payment_methods/domain/entities/payment_card.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_bloc.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_event.dart';
import 'package:basketapp/features/payment_methods/presentation/bloc/payment_method_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');

    if (text.isEmpty) return newValue.copyWith(text: '');
    if (text.length > 4) return oldValue;

    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) formatted += '/';
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AddCardScreen extends StatefulWidget {
  final PaymentMethodBloc bloc;

  const AddCardScreen({super.key, required this.bloc});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardholderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardholderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  CardBrand _detectBrand(String number) {
    if (number.startsWith('4')) return CardBrand.visa;
    if (number.startsWith('5')) return CardBrand.mastercard;
    if (number.startsWith('34') || number.startsWith('37')) {
      return CardBrand.amex;
    }
    return CardBrand.other;
  }

  void _saveCard() {
    if (!_formKey.currentState!.validate()) return;

    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final last4 = cardNumber.substring(cardNumber.length - 4);
    final brand = _detectBrand(cardNumber);
    final expiryParts = _expiryController.text.split('/');
    final month = int.parse(expiryParts[0]);
    final year = int.parse(expiryParts[1]);

    final card = PaymentCard(
      id: '',
      cardholderName: _cardholderController.text,
      last4: last4,
      brand: brand,
      expiryMonth: month,
      expiryYear: 2000 + year,
      createdAt: DateTime.now(),
    );

    widget.bloc.add(AddPaymentCardEvent(card));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentMethodBloc, PaymentMethodState>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (state is PaymentCardAdded) {
          Navigator.pop(context, state.card);
        } else if (state is PaymentMethodError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Agregar Tarjeta'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<PaymentMethodBloc, PaymentMethodState>(
          bloc: widget.bloc,
          builder: (context, state) {
            final isLoading = state is PaymentMethodLoading;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Número de Tarjeta',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                      ],
                      decoration: InputDecoration(
                        hintText: '0000 0000 0000 0000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El número de tarjeta es requerido';
                        }
                        final digits = value.replaceAll(' ', '');
                        if (digits.length < 13 || digits.length > 19) {
                          return 'El número de tarjeta debe tener entre 13 y 19 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nombre del Titular',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _cardholderController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Nombre como aparece en la tarjeta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El nombre del titular es requerido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Vencimiento',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _expiryController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  _ExpiryDateFormatter(),
                                ],
                                decoration: InputDecoration(
                                  hintText: 'MM/AA',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Requerido';
                                  }
                                  if (!value.contains('/')) {
                                    return 'Formato MM/AA';
                                  }
                                  try {
                                    final parts = value.split('/');
                                    final month = int.parse(parts[0]);
                                    final year = int.parse(parts[1]);

                                    if (month < 1 || month > 12) {
                                      return 'Mes inválido';
                                    }

                                    final now = DateTime.now();
                                    final expiryYear = 2000 + year;
                                    if (expiryYear < now.year ||
                                        (expiryYear == now.year &&
                                            month < now.month)) {
                                      return 'Tarjeta vencida';
                                    }
                                    return null;
                                  } catch (e) {
                                    return 'Formato inválido';
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CVV',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _cvvController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: '000',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'CVV requerido';
                                  }
                                  if (value.length < 3 || value.length > 4) {
                                    return 'CVV inválido';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveCard,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.deepPurple,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Guardar Tarjeta',
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
            );
          },
        ),
      ),
    );
  }
}
