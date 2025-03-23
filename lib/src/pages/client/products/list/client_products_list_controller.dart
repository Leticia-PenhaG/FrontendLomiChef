import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/category.dart';
import 'package:lomi_chef_to_go/src/provider/categories_provider.dart';
import 'package:lomi_chef_to_go/src/provider/products_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

import '../../../../models/product.dart';
import '../../../../models/user.dart';

class ClientProductsListController {
  BuildContext? context;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>(); //para poder desplegar el menu de opciones lateral
  late User user;
  late Function refresh;
  CategoriesProvider _categoriesProvider = new CategoriesProvider();
  ProductsProvider _productsProvider = new ProductsProvider();

  List<Category> categories = [];

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user')); //datos de usuario guardados
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    getCategories();
    refresh();
  }

  Future<List<Product>> getProducts(String idCategory) async{
    return await _productsProvider.getProductByCategory(idCategory);
  }

  void logout() {
    if (context == null) {
      print('Error: El contexto no ha sido inicializado.');
      return;
    }
    _sharedPreferencesHelper.logout(context!, user.id!);
  }

  void getCategories() async{
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  bool isInitialized() {
    return context != null;
  }

  void openDrawerBar() {
    key.currentState?.openDrawer(); //menu de opciones lateral
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }

  void goToUpdatePage(){
    Navigator.pushNamed(context!, 'client/update');
  }
}