import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/login/login_page.dart';
import 'package:lomi_chef_to_go/src/pages/register/register_page.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:lomi_chef_to_go/src/roles/roles_page.dart';

import 'src/utils/app_colors.dart';

/*void main() {
  runApp(const LomiChefDeliveryApp());
}

class LomiChefDeliveryApp extends StatefulWidget {
  const LomiChefDeliveryApp({super.key});

  @override
  State<LomiChefDeliveryApp> createState() => _LomiChefDeliveryAppState();
}

class _LomiChefDeliveryAppState extends State<LomiChefDeliveryApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Food Delivery- Lomi Chef',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'client/products/list' : (BuildContext context) => ClientProductsListPage(),
        'delivery/orders/list' : (BuildContext context) => DeliveryOrdersListPage(),
        'restaurant/orders/list' : (BuildContext context) => RestaurantOrdersListPage(),
        'roles' : (BuildContext context) => RolesPage(),
      },
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}*/

void main() {
  runApp(const LomiChefDeliveryApp());
}

class LomiChefDeliveryApp extends StatefulWidget {
  const LomiChefDeliveryApp({super.key});

  @override
  State<LomiChefDeliveryApp> createState() => _LomiChefDeliveryAppState();
}

class _LomiChefDeliveryAppState extends State<LomiChefDeliveryApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Food Delivery - Lomi Chef',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case 'register':
            return MaterialPageRoute(builder: (_) => RegisterPage());
          case 'client/products/list':
            return MaterialPageRoute(builder: (_) => ClientProductsListPage());
          case 'delivery/orders/list':
            return MaterialPageRoute(builder: (_) => DeliveryOrdersListPage());
          case 'restaurant/orders/list':
            return MaterialPageRoute(builder: (_) => RestaurantOrdersListPage());
          case 'roles':
          // Se obtienen los parámetros para RolesPage
            final arguments = settings.arguments as List<Map<String, dynamic>>?;
            final roles = arguments ?? [
              {"id": 1, "name": "CLIENTE", "route": "client/products/list"},
              {"id": 2, "name": "RESTAURANTE", "route": "restaurant/orders/list"},
              {"id": 3, "name": "REPARTIDOR", "route": "delivery/orders/list"},
            ];
            return MaterialPageRoute(
              builder: (_) => RolesPage(roles: roles),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Página no encontrada')),
              ),
            );
        }
      },
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
