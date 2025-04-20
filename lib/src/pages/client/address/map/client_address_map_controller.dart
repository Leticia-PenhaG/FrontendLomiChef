
import 'package:flutter/material.dart';

class ClientAddressMapController {

  BuildContext? context;
  Function? refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }
}