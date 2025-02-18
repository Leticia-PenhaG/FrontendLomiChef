
import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class RestaurantCategoriesCreatePage extends StatefulWidget {
  const RestaurantCategoriesCreatePage({super.key});

  @override
  State<RestaurantCategoriesCreatePage> createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {
  bool isBtnCreateEnabled = false; // Controla si el botón está habilitado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva categoría'),
      ),
      bottomNavigationBar: _buttonCreate(),
      //body: _buildForm(), // Agrega el formulario si es necesario
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          setState(() {
            isBtnCreateEnabled = value.isNotEmpty; // Habilita el botón si hay texto
          });
        },
        decoration: const InputDecoration(
          labelText: 'Nombre de la categoría',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buttonCreate() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: () {} ,//isBtnCreateEnabled ? _createCategory : null, // Botón habilitado o deshabilitado
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text('Crear categoría', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }

  void _createCategory() {
    // Aquí puedes manejar la creación de la categoría
    print('Categoría creada');
  }
}
