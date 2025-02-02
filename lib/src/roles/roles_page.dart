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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Muestra 2 columnas
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.9, // Ajusta la proporción de las tarjetas
          ),
          itemCount: _rolesController.user.roles?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final Rol rol = _rolesController.user.roles![index];
            return _cardRol(rol);
          },
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () {
        _rolesController.goToHomePage(rol.route);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: AssetImage(_getRoleImage(rol.name)),
              ),
              const SizedBox(height: 12),
              Text(
                rol.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {}); // Asegura que la UI se actualiza después de la carga de datos
  }

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
}

