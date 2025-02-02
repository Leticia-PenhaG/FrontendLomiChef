import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/roles/roles_controller.dart';
import '../models/rol.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final RolesController _rolesController = RolesController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _rolesController.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccioná un rol'),
      ),
      body: ListView(
        children: _rolesController.user.roles?.map((Rol rol) {
              return _cardRol(rol);
            }).toList() ??
            [], // Evita problemas si `roles` es `null`
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _rolesController.goToHomePage(rol.route);
      },
      child: Column(
        children: [
          Container(
            height: 100,
            child: FadeInImage(
              image: AssetImage(_getRoleImage(rol.name)),
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image-icon.png'),
            ),
          ),
          Text(
            rol.name ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(
        () {}); // Asegura que la UI se actualiza después de la carga de datos
  }
}

// Método para obtener la imagen correspondiente al rol
String _getRoleImage(String roleName) {
  switch (roleName.toUpperCase()) {
    case 'CLIENTE':
      return 'assets/img/client.png';
    case 'RESTAURANTE':
      return 'assets/img/restaurant.png';
    case 'REPARTIDOR':
      return 'assets/img/delivery.png';
    default:
      return 'assets/img/no-image-icon.png';
  }
}
