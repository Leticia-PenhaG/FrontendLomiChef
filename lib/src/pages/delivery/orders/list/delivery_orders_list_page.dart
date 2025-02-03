import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/delivery/orders/list/delivery_orders_list_controller.dart';
import '../../../../utils/app_colors.dart';

class DeliveryOrdersListPage extends StatefulWidget {
  const DeliveryOrdersListPage({super.key});

  @override
  State<DeliveryOrdersListPage> createState() => _DeliveryOrdersListPageState();
}

class _DeliveryOrdersListPageState extends State<DeliveryOrdersListPage> {
  final DeliveryOrdersListController _controllerDelivery = DeliveryOrdersListController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _controllerDelivery.init(context, refresh);
      setState(() {
        _isInitialized = true; // Cambia el estado una vez que `context` está listo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _controllerDelivery.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        child:Text('Delivery Page'),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _controllerDelivery.openDrawerBar,
      child: Container (
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20),
      ),
    );

  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  Color(0xff5cd0b3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: (_controllerDelivery.user.image != null && _controllerDelivery.user.image!.isNotEmpty)
                      ? NetworkImage(_controllerDelivery.user.image!) as ImageProvider
                      : const AssetImage('assets/img/no-image-icon.png'),
                ),
                const SizedBox(height: 10),

                Text(
                  '${_controllerDelivery.user.name ?? ''} ${_controllerDelivery.user.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerDelivery.user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerDelivery.user.phone ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Lista de opciones del Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (_controllerDelivery.user != null &&
                    _controllerDelivery.user.roles!.length > 1)
                  _buildDrawerItem(
                    Icons.person,
                    'Seleccionar rol',
                    _controllerDelivery.goToRoles,
                  ) ,

                //const Divider(),

                _buildDrawerItem(Icons.power_settings_new, 'Cerrar sesión', () {
                  _controllerDelivery.logout();
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }


// Función para construir ListTiles de manera más reutilizable
  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
      onTap: onTap,
    );
  }

  void refresh(){
    setState(() {

    });
  }

/*
  Widget _drawer() {
    return Drawer (
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: AppColors.primaryColor
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //izq.
                  children: [
                    Text('Nombre de usuario',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                    ),
                    Text('Email',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[300],
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                      maxLines: 1,
                    ),
                    Text('Teléfono',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[300],
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.only(top: 8),
                      child: FadeInImage(
                        image: AssetImage('assets/img/no-image-icon.png'),
                        fit: BoxFit.contain,
                        fadeInDuration: Duration(milliseconds: 50),
                        placeholder: AssetImage('assets/img/no-image.png'),
                      ),
                    )
                  ]
              )
          ),
          ListTile(
              title: Text('Seleccionar rol'),
              trailing: Icon(Icons.person)
          ),
          ListTile(
              onTap: _controllerDelivery.logout,
              title: Text('Cerrar sesión'),
              trailing: Icon(Icons.power_settings_new)
          ),
        ],
      ),
    );
  }*/
}
