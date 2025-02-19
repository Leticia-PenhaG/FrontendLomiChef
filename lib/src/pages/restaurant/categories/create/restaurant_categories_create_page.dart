
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class RestaurantCategoriesCreatePage extends StatefulWidget {
  const RestaurantCategoriesCreatePage({super.key});

  @override
  State<RestaurantCategoriesCreatePage> createState() => _RestaurantCategoriesCreatePageState();
}

class _RestaurantCategoriesCreatePageState extends State<RestaurantCategoriesCreatePage> {
  bool isBtnCreateEnabled = false; // Controla si el botón está habilitado

  final RestaurantCategoriesCreateController _controllerCategories= RestaurantCategoriesCreateController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _controllerCategories.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva categoría'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          _textFieldName(),
          _textFieldDescription()
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );

  }

  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _controllerCategories.nameController,
        decoration: InputDecoration(
          hintText: 'Nombre de la categoría',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: Colors.black
          ),
          suffixIcon: Icon(
            Icons.list_alt,
            color: Colors.black,
          )
        ),
      ),
    );
  }

  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _controllerCategories.descriptionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: 'Descripción de la categoría',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: Colors.black
            ),
            suffixIcon: Icon(
              Icons.description,
              color: Colors.black,
            )
        ),
      ),
    );
  }

  Widget _buttonCreate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SizedBox(
        width: double.infinity,
        height: 50, // Mantiene altura consistente
        child: ElevatedButton(
          onPressed: _controllerCategories.createCategory, // Implementa lógica aquí
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Crear categoría',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff38c2a6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(
          fontSize: 14,
          overflow: TextOverflow.ellipsis, // Controla el desbordamiento
        ),
      ),
      validator: validator,
    );
  }

  void refresh() {
    setState(() {

    });

  }
}
