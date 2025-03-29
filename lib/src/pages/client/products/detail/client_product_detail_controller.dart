
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

import '../../../../models/product.dart';

class ClientProductDetailController {
  BuildContext? context;
  Function? refresh;
  Product? product;

  int counter = 1;
  double productPrice = 0;

  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  List<Product> selectedProducts = [];

  void init(BuildContext context, Function refresh, Product? product) async{
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product?.price ?? 0;

    //_sharedPreferencesHelper.clearSession('order');
    selectedProducts = Product.fromJsonList(await _sharedPreferencesHelper.readSessionToken('order')).toList;    //PARA CONTROLAR QUÉ PRODUCTOS YA FUERON AÑADIDOS Y NO PERDER LA LISTA AL AGREGAR NUEVOS PRODUCTOS

    selectedProducts.forEach((prod) {
      print('Producto seleccionado ${prod.toJson()}');
    });
    
    refresh();
  }

  void addItem() {
    counter++;
    productPrice = (product?.price ?? 0) * counter;
    if (product != null) {
      product!.quantity = counter;
    }
    refresh?.call();
  }

  void removeItem() {
    if (counter > 1) {
      counter--;
      productPrice = (product?.price ?? 0) * counter;
      if (product != null) {
        product!.quantity = counter;
      }
      refresh?.call();
    }
  }

  void addToShoppingCart() {
    int index = selectedProducts.indexWhere((prod) => prod.id == product?.id); //para saber si en la lista de productos seleccionados ya está el producto que seleccino, en ese caso solo cambia la cantidad del producto

    if(index == -1) { // si el producto no existe aún en la lista que ya se seleccionó
      if(product?.quantity == null) {
        product?.quantity = 1;
      }
      selectedProducts.add(product!);
    } else {
      selectedProducts[index].quantity = counter ;//si ya existe el producto en la lista, solo se modifica la cantidad
    }

    //selectedProducts.add(product!);
    _sharedPreferencesHelper.saveSessionToken('order', selectedProducts); //se van guardando en el share preference los productos seleccionados
    Fluttertoast.showToast(msg: 'PRODUCTO AGREGADO');
  }
}
