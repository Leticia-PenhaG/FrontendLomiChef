import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/map/client_address_map_controller.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({super.key});

  @override
  State<ClientAddressMapPage> createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {
  final ClientAddressMapController _controller = ClientAddressMapController();

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
        title: const Text('Ubicá tu dirección en el mapa'),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

