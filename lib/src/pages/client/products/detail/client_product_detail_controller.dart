
import 'package:flutter/material.dart';

class ClientProductDetailController {
  BuildContext? context;
  late Function refresh;

  Future(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;
    refresh();
  }



}