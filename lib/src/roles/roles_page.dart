import 'package:flutter/material.dart';

class RolesPage extends StatelessWidget {
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
}

