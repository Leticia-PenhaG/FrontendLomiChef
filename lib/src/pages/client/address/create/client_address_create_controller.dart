
import 'package:flutter/material.dart';

class ClientAddressCreateController {

  BuildContext? context;
  Function? refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

  }


}