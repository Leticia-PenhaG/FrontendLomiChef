
import 'package:flutter/material.dart';

import '../../../../models/product.dart';

class ClientProductDetailController {
  BuildContext? context;
  Function? refresh;
  Product? product;

  int counter = 1;
  double productPrice = 0;

  void init(BuildContext context, Function refresh, Product? product) {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    productPrice = product?.price ?? 0;
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
}
