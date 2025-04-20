import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      body: SafeArea(
        child: Stack(
          children: [
            _googleMaps(),
            Align(
              alignment: Alignment.center,
              child: _iconActualLocation(),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: _cardAddress(),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: _buttonAccept(),
            )
          ],
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _controller.initialPosition,
      onMapCreated: _controller.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
    );
  }

  Widget _cardAddress() {
    return Card(
      color: Colors.grey[800],
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Text(
          'Calle',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _iconActualLocation() {
    return Image.asset(
      'assets/img/location_map_pin_mark_icon.png',
      width: 65,
      height: 65,
    );
  }

  Widget _buttonAccept() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.location_on, color: Colors.white),
        label: const Text(
          'Aceptar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

