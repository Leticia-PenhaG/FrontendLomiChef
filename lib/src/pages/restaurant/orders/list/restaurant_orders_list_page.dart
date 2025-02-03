import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import '../../../../utils/app_colors.dart';

class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({super.key});

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {

  final RestaurantOrdersListController _restaurantOrdersListController = RestaurantOrdersListController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _restaurantOrdersListController.init(context, refresh);
      setState(() {
        _isInitialized = true; // Cambia el estado una vez que `context` está listo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _restaurantOrdersListController.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        child:Text('Restaurant Page'),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _restaurantOrdersListController.openDrawerBar,
      child: Container (
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20,),
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
                  backgroundImage: (_restaurantOrdersListController.user.image != null && _restaurantOrdersListController.user.image!.isNotEmpty)
                      ? NetworkImage(_restaurantOrdersListController.user.image!) as ImageProvider
                      : const AssetImage('assets/img/no-image-icon.png'),
                ),
                const SizedBox(height: 10),

                Text(
                  '${_restaurantOrdersListController.user.name ?? ''} ${_restaurantOrdersListController.user.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _restaurantOrdersListController.user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _restaurantOrdersListController.user.phone ?? '',
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
                if (_restaurantOrdersListController.user != null &&
                    _restaurantOrdersListController.user.roles!.length > 1)
                  _buildDrawerItem(
                    Icons.person,
                    'Seleccionar rol',
                    _restaurantOrdersListController.goToRoles,
                  ) ,

                //const Divider(),

                _buildDrawerItem(Icons.power_settings_new, 'Cerrar sesión', () {
                  _restaurantOrdersListController.logout();
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


/*  Widget _drawer() {
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
              onTap: _restaurantOrdersListController.logout,
              title: Text('Cerrar sesión'),
              trailing: Icon(Icons.power_settings_new)
          ),
        ],
      ),
    );
  }*/



}
