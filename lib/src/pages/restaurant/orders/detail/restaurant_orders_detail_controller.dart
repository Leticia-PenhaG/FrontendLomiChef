
import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../../../../models/product.dart';
import '../../../../models/order.dart';

class RestaurantOrdersDetailController {
  BuildContext? context;
  Function? refresh;
  Product? product;

  //añadir la cantidad del prducto en el share preference
  int counter = 1;
  double productPrice = 0;

  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  List<Product> selectedProducts = [];
  double total = 0;

  late Order order;

  void init(BuildContext context, Function refresh, Order order) async{
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    selectedProducts = Product.fromJsonList(await _sharedPreferencesHelper.readSessionToken('order')).toList; //trae del sharepreference la orden    //PARA CONTROLAR QUÉ PRODUCTOS YA FUERON AÑADIDOS Y NO PERDER LA LISTA AL AGREGAR NUEVOS PRODUCTOS

    getTotal();
    refresh();
  }

  void getTotal(){
    total = 0;
    selectedProducts.forEach((product) {
      if (product.price != null) {
        total = total + (product.quantity! * product.price!);
      }
    });

    refresh!();
  }

  void increaseQuantity(Product product) {
    int index = selectedProducts.indexWhere((prod) => prod.id == product.id);
    selectedProducts[index].quantity = (selectedProducts[index].quantity! + 1);
    _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
    getTotal();
  }

  void decreaseQuantity(Product product) {
    int index = selectedProducts.indexWhere((prod) => prod.id == product.id);
    if (selectedProducts[index].quantity! > 1) {
      selectedProducts[index].quantity = (selectedProducts[index].quantity! - 1);
      _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product){
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
    getTotal();
  }

  String formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void goToAddress() {
    Navigator.pushNamed(context!, 'client/address/list');
  }

}
