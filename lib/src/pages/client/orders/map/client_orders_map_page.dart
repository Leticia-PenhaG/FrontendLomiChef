import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../utils/app_colors.dart';
import 'client_orders_map_controller.dart';

class ClientOrdersMapPage extends StatefulWidget {
  const ClientOrdersMapPage({super.key});

  @override
  State<ClientOrdersMapPage> createState() => _ClientOrdersMapPageState();
}

class _ClientOrdersMapPageState extends State<ClientOrdersMapPage> {
  final ClientOrdersMapController _controller = ClientOrdersMapController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  void dispose() { //Cancelar el stream para evitar memory leaks
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: _googleMaps(),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buttonCenterPosition(),
                  Spacer(),
                  _cardOrderInfo(),
                ],
              ),
            ),
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
      polylines: _controller.polylines,
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(vertical:10, horizontal: 10),
        child: Card(
          shape: CircleBorder(),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color:Colors.grey[800],
                size: 20,
            )
          ),
        ),
      ),
    );
  }

  Widget _cardOrderInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Sombra ligera
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _listTitleAddress(_controller.order?.address?['neighborhood'] ?? '', 'Barrio', Icons.my_location_outlined),
          _listTitleAddress(_controller.order?.address?['address'] ?? '', 'Dirección', Icons.location_on_outlined),
          Divider(color: Colors.grey[400], endIndent: 30, indent: 30),
          _deliveryInfo(),
        ],
      ),
    );
  }

  Widget _listTitleAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title ?? 'Sin información',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: Icon(
          iconData,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Widget _deliveryInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: FadeInImage(
                image: _controller.order?.delivery?['image'] != null
                    ? NetworkImage(_controller.order?.delivery?['image'])
                    : AssetImage('assets/img/no-image-icon.png') as ImageProvider,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/no-image-icon.png'),
                fadeInDuration: Duration(milliseconds: 50),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_controller.order?.delivery?['name'] ?? ''} ${_controller.order?.delivery?['lastname'] ?? ''}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
          /*Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.phone_android, color: Colors.black),
            ),
          )*/ //PHONE ICON
        ],
      ),
    );
  }

  void refresh() {
    if(!mounted) return;
    setState(() {});
  }
}

