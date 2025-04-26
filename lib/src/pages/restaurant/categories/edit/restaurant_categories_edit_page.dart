import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../models/category.dart';
import '../../../../utils/app_colors.dart';
import '../create/restaurant_categories_create_controller.dart';

class RestaurantCategoriesEditPage extends StatefulWidget {
  final Category category;

  const RestaurantCategoriesEditPage({super.key, required this.category});

  @override
  State<RestaurantCategoriesEditPage> createState() => _RestaurantCategoriesEditPageState();
}

class _RestaurantCategoriesEditPageState extends State<RestaurantCategoriesEditPage> {
  final RestaurantCategoriesCreateController _controller = RestaurantCategoriesCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
      _controller.nameController.text = widget.category.name ?? '';
      _controller.descriptionController.text = widget.category.description ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _textFieldName(),
            const SizedBox(height: 20),
            _textFieldDescription(),
            const SizedBox(height: 30),
            _buttonUpdate(),
          ],
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return TextField(
      controller: _controller.nameController,
      decoration: const InputDecoration(labelText: 'Nombre de la Categoría'),
    );
  }

  Widget _textFieldDescription() {
    return TextField(
      controller: _controller.descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(labelText: 'Descripción'),
    );
  }

  Widget _buttonUpdate() {
    return ElevatedButton(
      onPressed: () {
        _controller.updateCategory(widget.category);
      },
      child: const Text('Actualizar'),
    );
  }

  void refresh() {
    setState(() {});
  }
}