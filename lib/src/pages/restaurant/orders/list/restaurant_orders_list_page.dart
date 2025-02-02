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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _restaurantOrdersListController.init(context);
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
  }
}
