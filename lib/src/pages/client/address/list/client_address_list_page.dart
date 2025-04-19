import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import 'package:lomi_chef_to_go/src/widgets/no_data_widget.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({super.key});

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  final ClientAddressListController _controller = ClientAddressListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direcciones'),
        actions: [
          _iconAdd(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textSelectedAddress(),
            const SizedBox(height: 16),
            NoDataWidget(text: 'Agregá una nueva dirección'),
            const SizedBox(height: 24),
            _buttonNewAddress(),
          ],
        ),
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _iconAdd() {
    return IconButton(
      onPressed: _controller.goToNewAddress,
      icon: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _textSelectedAddress() {
    return Text(
      'Elegí dónde querés recibir tus compras',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buttonAccept() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'ACEPTAR',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonNewAddress() {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _controller.goToNewAddress,
        icon: const Icon(Icons.location_on, color: Colors.white),
        label: const Text(
          'Agregar nueva dirección',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

