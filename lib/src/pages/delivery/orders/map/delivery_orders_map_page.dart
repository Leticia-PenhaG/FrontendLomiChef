import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../utils/app_colors.dart';
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
            Container
            (
                height: MediaQuery.of(context).size.height * 0.6,
                child: _googleMaps()
            ),
            // Align(
            //   alignment: Alignment.center,
            //   child: _iconActualLocation(),
            // ),
            SafeArea(
                child: Column(
              children:
              [
                _buttonCenterPosition(),
                Spacer(), //UBICA ABAJO
                _cardOrderInfo(),
              ],
            ))
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
          _listTitleAddress(_controller.order?.address?['neighborhood'], 'Barrio', Icons.my_location_outlined),
          _listTitleAddress(_controller.order?.address?['address'], 'Dirección', Icons.location_on_outlined),
          Divider(color: Colors.grey[400], endIndent: 30, indent: 30),
          _clientInfo(),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: _buttonAccept(),
          ),
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
          title ?? '',
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

  Widget _clientInfo() {
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
                image: _controller.order?.client?['image'] != null
                    ? NetworkImage(_controller.order?.client?['image'])
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
              '${_controller.order?.client?['name'] ?? ''} ${_controller.order?.client?['lastname'] ?? ''}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.grey[200],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.phone_android, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  // Widget _buttonAccept() {
  //   return SizedBox(
  //     height: 50,
  //     child: ElevatedButton.icon(
  //       onPressed: (){},
  //       icon: const Icon(Icons.location_on, color: Colors.white),
  //       label: const Text(
  //         'Entregar producto',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 16,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.blueAccent,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buttonAccept() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),  // Reduce vertical padding para evitar desbordamiento
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          child: const Text(
            'Entregar producto',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

