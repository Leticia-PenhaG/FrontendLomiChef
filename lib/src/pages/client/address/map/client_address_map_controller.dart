import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;


class ClientAddressMapController {
  BuildContext? context;
  Function? refresh;
  late Position _position;
  String? addressName = '';
  late LatLng addressLatLng;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    checkGPS();
  }

  /// Posición inicial por defecto en el mapa
  CameraPosition initialPosition =
      CameraPosition(target: LatLng(-25.1234927, -57.3510361), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  /// Callback que se llama cuando se crea el mapa.
  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  /// Actualiza la ubicación del usuario en el mapa.
  void updateLocation() async {
    try {
      await _determinePosition(); //solicitar permisos y hallar la posición actual
      _position = (await Geolocator
          .getLastKnownPosition())!; //latitud y longitud actual
      animateCameraToPosition(_position.latitude, _position.longitude);
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Verifica si el GPS está activo; si no, solicita activarlo.
  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  /// Mueve la cámara del mapa a la latitud y longitud especificada.
  Future animateCameraToPosition(double latitud, double longitud) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(latitud, longitud), zoom: 14, bearing: 0)));
    }
  }

  /// Solicita permisos de ubicación y retorna la posición actual del dispositivo.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  /// Obtiene la dirección actual del marcador en el centro del mapa y actualiza la interfaz.
  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double latitud = initialPosition.target.latitude;
      double longitud = initialPosition.target.longitude;

      List<Placemark> address =
          await placemarkFromCoordinates(latitud, longitud);

      if (address.isNotEmpty) {
        String? direction = address[0].thoroughfare ?? '';
        String? street = address[0].subThoroughfare;
        String? city = address[0].locality;
        String? department = address[0].administrativeArea;
        String? country = address[0].country;

        addressName = '$direction #$street, $city, $department';
        addressLatLng = LatLng(latitud, longitud);
        print('Latitud: ${addressLatLng.latitude}');
        print('Longitud: ${addressLatLng.longitude}');

        refresh?.call();
      }
    }
  }

  void selectReferencePoint() {
    Map<String, dynamic> data = {
      'address':addressName,
      'lat':addressLatLng.latitude,
      'lng':addressLatLng.longitude,
    };
    Navigator.pop(context!, data);
  }

}

