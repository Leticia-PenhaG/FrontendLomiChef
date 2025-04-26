import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../utils/app_colors.dart';
import '../create/restaurant_categories_create_controller.dart';
import '../create/restaurant_categories_create_page.dart';
import '../edit/restaurant_categories_edit_page.dart';

class RestaurantCategoriesListPage extends StatefulWidget {
  const RestaurantCategoriesListPage({super.key});

  @override
  State<RestaurantCategoriesListPage> createState() => _RestaurantCategoriesListPageState();
}

class _RestaurantCategoriesListPageState extends State<RestaurantCategoriesListPage> {
  final RestaurantCategoriesCreateController _controller = RestaurantCategoriesCreateController();
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
      loadCategories();
    });
  }

  void refresh() {
    setState(() {});
  }

  Future<void> loadCategories() async {
    categories = await _controller._categoriesProvider.getCategories();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: categories.isEmpty
          ? const Center(child: Text('No hay categorías disponibles'))
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(category.name ?? ''),
              subtitle: Text(category.description ?? ''),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantCategoriesEditPage(category: category),
                        ),
                      );
                      loadCategories(); // Recargar después de editar
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _controller.deleteCategory(category.id!);
                      loadCategories(); // Recargar después de eliminar
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RestaurantCategoriesCreatePage()),
          );
          loadCategories(); // Recargar después de crear
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
