import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/create/client_address_create_page.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/list/client_address_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/map/client_address_map_page.dart';
import 'package:lomi_chef_to_go/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/client/update/client_update_page.dart';
import 'package:lomi_chef_to_go/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/login/login_page.dart';
import 'package:lomi_chef_to_go/src/pages/register/register_page.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/categories/edit/restaurant_categories_edit_page.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:lomi_chef_to_go/src/roles/roles_page.dart';
import 'src/utils/app_colors.dart';

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
      title: 'Fast Food Delivery- Lomi Chef',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'client/products/list': (BuildContext context) => ClientProductsListPage(),
        'delivery/orders/list': (BuildContext context) => DeliveryOrdersListPage(),
        'restaurant/orders/list': (BuildContext context) => RestaurantOrdersListPage(),
        'restaurant/categories/create': (BuildContext context) => RestaurantCategoriesCreatePage(),
        'restaurant/categories/update': (BuildContext context) => RestaurantCategoriesEditPage(),
        'restaurant/categories/delete': (BuildContext context) => RestaurantCategoriesCreatePage(),
        'restaurant/products/create': (BuildContext context) => RestaurantProductsCreatePage(),
        'client/update': (BuildContext context) => ClientUpdatePage(),
        'client/orders/create': (BuildContext context) => ClientOrdersCreatePage(),
        'roles': (BuildContext context) => RolesPage(),
        'client/address/list': (BuildContext context) => ClientAddressListPage(),
        'client/address/create': (BuildContext context) => ClientAddressCreatePage(),
        'client/address/map': (BuildContext context) => ClientAddressMapPage(),
      },
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        appBarTheme: AppBarTheme(
           backgroundColor: AppColors.primaryColor,
          elevation: 0
        ),
      ),
    );
  }
}
