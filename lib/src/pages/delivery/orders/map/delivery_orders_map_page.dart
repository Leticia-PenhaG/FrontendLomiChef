import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'delivery_orders_map_controller.dart';

class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({super.key});

  @override
  State<DeliveryOrdersMapPage> createState() => _DeliveryOrdersMapPageState();
}

class _DeliveryOrdersMapPageState extends State<DeliveryOrdersMapPage> {
  final DeliveryOrdersMapController _controller = DeliveryOrdersMapController();

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
      body: SafeArea(
        child: Stack(
          children: [
            _googleMaps(),
            // Align(
            //   alignment: Alignment.center,
            //   child: _iconActualLocation(),
            // ),
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
      markers: Set<Marker>.of(_controller.markers.values),
    );
  }

  // Widget _iconActualLocation() {
  //   return Image.asset(
  //     'assets/img/location_map_pin_mark_icon.png',
  //     width: 65,
  //     height: 65,
  //   );
  // }

  Widget _buttonAccept() {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _controller.selectReferencePoint,
        icon: const Icon(Icons.location_on, color: Colors.white),
        label: const Text(
          'Seleccionar este punto',
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

