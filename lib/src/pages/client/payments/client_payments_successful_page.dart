import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'client_payments_status_controller.dart';

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
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {});
  }

  Widget _clipPathOval() {
    return ClipPath(
      clipper: OvalBottomBorderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: MyColors.primaryColor,
        child: SafeArea(
          child: Column(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 150),
              const Text(
                'Gracias por tu compra',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textCardDetail() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: const Text(
        'Tu orden fue procesada exitosamente',
        style: TextStyle(
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _textCardStatus() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: const Text(
        'Mira el estado de tu compra en la seccion de MIS PEDIDOS',
        style: TextStyle(
          fontSize: 17,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.finishShopping,
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  'FINALIZAR COMPRA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 50, top: 2),
                height: 30,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _clipPathOval(),
          _textCardDetail(),
          _textCardStatus(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: _buttonNext(),
      ),
    );
  }
}