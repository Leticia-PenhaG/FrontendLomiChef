
import 'package:flutter/material.dart';

class ClientPaymentsStatusController {
  BuildContext? context;
  Function? refresh;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  void finishShopping() {
    Navigator.pushNamedAndRemoveUntil(context!, 'client/products/list', (route) => false);
  }
}
