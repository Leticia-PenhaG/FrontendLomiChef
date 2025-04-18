
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

import '../../../../models/product.dart';

class ClientsOrdersCreateController {
  BuildContext? context;
  Function? refresh;
  Product? product;

  //añadir la cantidad del prducto en el share preference
  int counter = 1;
  double productPrice = 0;

  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  List<Product> selectedProducts = [];
  double total = 0;

  void init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

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
    return price.toInt().toString(); // O usar NumberFormat si querés separador de miles
  }

}
