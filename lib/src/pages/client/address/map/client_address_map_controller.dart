
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapController {

  BuildContext? context;
  Function? refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(-25.1234927, -57.3510361),
      zoom:14
  );

  Completer<GoogleMapController> _mapController = Completer();

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }
}
