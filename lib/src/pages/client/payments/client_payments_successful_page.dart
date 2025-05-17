import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'client_payments_status_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class ClientPaymentsSuccessfulPage extends StatefulWidget {
  const ClientPaymentsSuccessfulPage({Key? key}) : super(key: key);

  @override
  State<ClientPaymentsSuccessfulPage> createState() => _ClientPaymentsSuccessfulPageState();
}

class _ClientPaymentsSuccessfulPageState extends State<ClientPaymentsSuccessfulPage> {
  final ClientPaymentsStatusController _con = ClientPaymentsStatusController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE9F5F2), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: const Icon(Icons.check, color: Colors.green, size: 80),
            ),
            const SizedBox(height: 30),
            const Text(
              '¡Pago exitoso!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Gracias por tu compra',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Podés seguir el estado de tu pedido en la sección "Mis Pedidos".',
              style: TextStyle(fontSize: 16, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            _buildFinishButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _con.finishShopping,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Finalizar',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}