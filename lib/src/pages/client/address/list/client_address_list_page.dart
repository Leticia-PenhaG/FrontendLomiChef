import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import '../../../../models/Address.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({super.key});

  @override
  State<ClientAddressListPage> createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  final ClientAddressListController _controller = ClientAddressListController();
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direcciones'),
        actions: [
          IconButton(
            onPressed: _controller.goToNewAddress,
            icon: const Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: FutureBuilder<List<Address>>(
        future: _controller.getAddress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _noAddressContent();
          }

          List<Address> addresses = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Elegí dónde querés recibir tus compras',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...addresses.map((address) => RadioListTile(
                title: Text(address.address),
                subtitle: Text(address.neighborhood),
                // value: address.id,
                // groupValue: _selectedAddressId,
                // onChanged: (value) {
                //   setState(() {
                //     _selectedAddressId = value.toString();
                //   });
                // },
                value: address.id,
                groupValue: _controller.selectedAddressId,
                onChanged: (value) {
                  _controller.onAddressSelected(value.toString())();
                },
              )),
              const SizedBox(height: 24),
              //_buttonNewAddress(),
            ],
          );
        },
      ),

      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _noAddressContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/no_items.png',
              height: 180,
            ),
            const SizedBox(height: 24),
            const Text(
              'No tenés direcciones registradas aún.\nAgregá una para continuar con tu compra.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            //_buttonNewAddress(),
          ],
        ),
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
          // onPressed: _selectedAddressId == null
          //     ? null
          //     : () => _controller.onAddressSelected(_selectedAddressId!)(),
          /*onPressed: _controller.selectedAddressId == null
              ? null
              : () => _controller.onAddressSelected(_controller.selectedAddressId!)(),*/
          //onPressed: _controller.createOrder,
          onPressed: _controller.selectedAddressId == null
              ? null
              : () => _controller.paymentSheetInitialization("20", "USD"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Pagar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


