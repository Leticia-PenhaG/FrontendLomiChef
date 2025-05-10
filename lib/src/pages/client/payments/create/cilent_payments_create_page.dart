import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:lomi_chef_to_go/src/pages/client/payments/create/client_payments_create_controller.dart';

import '../../../../models/user.dart';
import '../../../../utils/app_colors.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({super.key});

  @override
  State<ClientPaymentsCreatePage> createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage> {
  ClientPaymentsCreateController _controller = ClientPaymentsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: const Text('Método de Pago'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CreditCardWidget(
                cardNumber: _controller.cardNumber,
                expiryDate: _controller.expiryDate,
                cardHolderName: _controller.cardHolderName,
                cvvCode: _controller.cvvCode,
                cardBgColor: Color(0xff1b5e5e),
                showBackView: _controller.isCvvFocused,
                obscureCardCvv: true,
                labelCardHolder: 'Nombre y Apellido',
                isHolderNameVisible: true,
                onCreditCardWidgetChange: (brand) {},
              ),
              const SizedBox(height: 20),
              CreditCardForm(
                formKey: _controller.formKey,
                cardNumber: _controller.cardNumber,
                expiryDate: _controller.expiryDate,
                cardHolderName: _controller.cardHolderName,
                cvvCode: _controller.cvvCode,
                onCreditCardModelChange: _controller.onCreditCardModelChanged,
                obscureCvv: true,
                obscureNumber: true,
                isHolderNameVisible: true,
                inputConfiguration: const InputConfiguration(
                  cardNumberDecoration: InputDecoration(
                    labelText: 'Número de tarjeta',
                    hintText: 'XXXX XXXX XXXX XXXX',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  expiryDateDecoration: InputDecoration(
                    labelText: 'Fecha de expiración',
                    hintText: 'MM/AA',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  cvvCodeDecoration: InputDecoration(
                    labelText: 'CVV',
                    hintText: 'XXX',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  cardHolderDecoration: InputDecoration(
                    labelText: 'Nombre del titular',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _documentFields(), // Campo C.C. y número de documento
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Acción del botón
                },
                // icon: const Icon(Icons.payment),
                label: const Text('Continuar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor, // color del fondo del botón
                  foregroundColor: Colors.white, // color del texto (y del ícono si hay)
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _documentFields() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Tipo doc.',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            value: 'C.C.',
            items: const [
              DropdownMenuItem(value: 'C.C.', child: Text('C.C.')),
              DropdownMenuItem(value: 'RUC', child: Text('RUC')),
              DropdownMenuItem(value: 'DNI', child: Text('DNI')),
            ],
            onChanged: (value) {
              // handle document type selection
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 4,
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Número de documento',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
