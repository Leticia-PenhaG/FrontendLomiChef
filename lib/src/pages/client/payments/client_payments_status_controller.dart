
import 'package:flutter/material.dart';

class ClientPaymentsStatusController {
  BuildContext? context;
  Function? refresh;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    // Puedes agregar inicializaciones adicionales aquí si es necesario
  }

  void finishShopping() {
    Navigator.pushNamedAndRemoveUntil(context!, 'client/products/list', (route) => false);
  }
}

class OvalBottomBorderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class MyColors {
  static const Color primaryColor = Colors.deepPurpleAccent; // Puedes definir tu color primario aquí
}