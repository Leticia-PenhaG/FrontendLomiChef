import 'dart:async';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import '../../../../api/environment.dart';
import '../../../../models/order.dart';
import '../../../../models/user.dart';
import '../../../../utils/shared_preferences_helper.dart';
import '../../../../utils/snackbar_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO ;

class ClientOrdersMapController {
  BuildContext? context;
  Function? refresh;
  late Position _position;
  String? addressName = '';
  late LatLng addressLatLng;
  late BitmapDescriptor deliveryMarker;
  late BitmapDescriptor homeMarker;
  Order? order;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{
  };
  Set<Polyline> polylines = {}; //trazado de ruta
  List<LatLng> points = [];
  OrdersProvider _ordersProvider = new OrdersProvider();
  late User sessionUser;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  late double _distanceBetween;
  IO.Socket? socket;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    order = Order.fromJson(ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>);
    deliveryMarker = await createMarkerFromImage('assets/img/delivery.png');
    homeMarker = await createMarkerFromImage('assets/img/house.png');

    socket = IO.io('http://${Environment.API_DELIVERY}/orders/delivery',<String, dynamic>{
      'transports':['websocket'],
      'autoConnect':false
    });

    socket?.connect();

    socket?.on('position/${order?.id}', (data) {
      print('Datos emitidos:${data}');
    });

    sessionUser = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _ordersProvider.init(context, sessionUser);

    print('ORDEN:${order?.toJson()}');
    checkGPS();
  }

  /// Agrega un marcador personalizado al mapa con latitud, longitud e información.
  void addMarker(String markerId, double lat, double lng, String title,
      String content, BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content));
    markers[id] = marker;
    refresh!();
  }

  /// Posición inicial por defecto en el mapa
  CameraPosition initialPosition =
  CameraPosition(target: LatLng(-25.1234927, -57.3510361), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  /// Callback que se llama cuando se crea el mapa.
  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  void dispose() {
    socket?.disconnect();
  }

  /// Actualiza la ubicación del usuario y centra la cámara en esa posición.
  void updateLocation() async {
    try {
      await _determinePosition(); //solicitar permisos y hallar la posición actual
      _position = (await Geolocator
          .getLastKnownPosition())!; //latitud y longitud actual
      /// Mueve la cámara del mapa a la latitud y longitud especificada.
      animateCameraToPosition(_position.latitude, _position.longitude);

      addMarker
        (
          'delivery',
          _position.latitude,
          _position.longitude,
          'Tu posición',
          '',
          deliveryMarker
      );

        addMarker(
          'home',
          order?.address?['lat'],
          order?.address?['lng'],
          'Lugar de entrega',
          '',
          homeMarker,
        );

        LatLng from = new LatLng(_position.latitude, _position.longitude);
        LatLng to = new LatLng(order?.address?['lat'], order?.address?['lng']);

        setPolylines(from, to);

      refresh!();

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

  /// Cierra la pantalla actual y retorna la dirección seleccionada.
  void selectReferencePoint() {
    Map<String, dynamic> data = {
      'address':addressName,
      'lat':addressLatLng.latitude,
      'lng':addressLatLng.longitude,
    };
    Navigator.pop(context!, data);
  }


  /// Crea un marcador personalizado a partir de una imagen de assets.
  Future<BitmapDescriptor> createMarkerFromImage(String path) async {
    final ByteData byteData = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetWidth: 150,
      targetHeight: 150,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? resizedData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(resizedData!.buffer.asUint8List());
  }

  /*Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(from.latitude, from.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_GOOGLE_MAPS,
        pointFrom,
        pointTo
    );

    for(PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(polylineId: PolylineId('poly-routes'),
    color: AppColors.primaryColor,
    points: points,
    width: 5);

    polylines.add(polyline); // ← Aquí va el correcto uso de `add`
    refresh!();
  }*/

  Future<void> setPolylines(LatLng from, LatLng to) async {
    // Limpiar puntos anteriores si es necesario
    points.clear();

    // Crear los puntos de origen y destino correctamente
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);

    // Obtener la ruta usando la nueva API con PolylineRequest
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Environment.API_KEY_GOOGLE_MAPS,
      request: PolylineRequest(
        origin: pointFrom,
        destination: pointTo,
        mode: TravelMode.driving,
      ),
    );

    // Verificar si hay puntos válidos
    if (result.points.isNotEmpty) {
      for (PointLatLng point in result.points) {
        points.add(LatLng(point.latitude, point.longitude));
      }

      Polyline polyline = Polyline(
        polylineId: PolylineId('poly-routes'),
        color: Colors.deepOrange,
        points: points,
        width: 5,
      );

      polylines.add(polyline); // Agregar la polilínea al conjunto
    } else {
      print('No se encontraron puntos en la ruta.');
    }

    refresh?.call();
  }

  void updateToDeliveryCompleted() async {
    ResponseApi? responseApi = await _ordersProvider.updateToDeliveryCompleted(order!);
    if (_distanceBetween <= 1500) {
      if (responseApi!.success) {
        Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(
            context!, 'delivery/orders/list', (route) => false);
      }
    } else {
      SnackbarHelper.show(context: context!, message: 'Tenés que estar cerca de la dirección de entrega');
    }
  }

  // void launchWaze() async {
  //   var url = 'waze://?ll=${order!.address['lat'].toString()},${order?.address['lng'].toString()}';
  //   var fallbackUrl =
  //       'https://waze.com/ul?ll=${order!.address['lat'].toString()},${order?.address['lng'].toString()}&navigate=yes';
  //   try {
  //     bool launched =
  //     await launch(url, forceSafariVC: false, forceWebView: false);
  //     if (!launched) {
  //       await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  //     }
  //   } catch (e) {
  //     await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
  //   }
  // }



  void launchGoogleMaps() async {
    final lat = order!.address?['lat'];
    final lng = order!.address?['lng'];

    if (lat == null || lng == null) return;

    final url = 'google.navigation:q=$lat,$lng&mode=d';
    final fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';

    try {
      final bool launched = await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
      if (!launched) {
        await launch(
          fallbackUrl,
          forceSafariVC: false,
          forceWebView: false,
        );
      }
    } catch (e) {
      await launch(
        fallbackUrl,
        forceSafariVC: false,
        forceWebView: false,
      );
    }
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(_position.latitude, _position.longitude, order!.address?['lat'], order!.address?['lng']);
    print('Distancia del delivery:${_distanceBetween}');
  }
}


