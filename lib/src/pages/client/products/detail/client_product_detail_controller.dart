
import 'package:flutter/material.dart';

import '../../../../models/product.dart';

class ClientProductDetailController {
  BuildContext? context;
  late Function refresh;
  Product? product;

  Future<void> init(BuildContext context, Function refresh, Product? product) async {
    this.context = context;
    this.refresh = refresh;
    this.product = product;
    refresh();
  }



}