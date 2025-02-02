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
    setState(() {}); // Asegura que la UI se actualiza después de la carga de datos

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


/*class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super (key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  final RolesController _rolesController = RolesController();
  @override
  void initState(){
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _rolesController.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccioná un rol),
      ),
      body: ListView(
      children: _rolesController.user != null ? _rolesController.user.roles.map((Rol rol) {
        return _cardRol(rol);
    }).toList() : []
    )
    );
   }

  Widget _cardRol(Rol rol) {
    return Column(
        children: [
          Container(
            height: 100,
            child: FadeInImage(
              image: rol.image != null
                  ? NetworkImage(rol.image)
                  : AssetImage('assets/img/no-image-icon.png'),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image-icon.png'),
            ),
            Text(
              rol.name ?? '',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black
              ),
            ),
          )

    ],
    );

  }
}*/


/*class RolesPage extends StatelessWidget {
  final List<Map<String, dynamic>> roles;

  const RolesPage({Key? key, required this.roles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccioná un Rol'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Dos agrupan en columnas
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: roles.length,
          itemBuilder: (BuildContext context, int index) {
            final role = roles[index];

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, role['route']);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      radius: 36,
                      child: Icon(
                        _getIconForRole(role['id']),
                        size: 36,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      role['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Método para obtener un ícono basado en el ID del rol
  IconData _getIconForRole(int roleId) {
    switch (roleId) {
      case 1:
        return Icons.shopping_cart;
      case 2:
        return Icons.restaurant_menu;
      case 3:
        return Icons.delivery_dining;
      default:
        return Icons.person;
    }
  }
}*/
