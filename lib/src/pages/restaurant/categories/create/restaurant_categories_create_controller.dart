import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/provider/categories_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../../../../models/category.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../utils/snackbar_helper.dart';

class RestaurantCategoriesCreateController {
  late final BuildContext context;
  late Function refresh;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  late User user;
  SharedPreferencesHelper sharedPref = new SharedPreferencesHelper();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.readSessionToken('user'));
    _categoriesProvider.init(context, user);
  }

  void createCategory() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      SnackbarHelper.show(
          context: context, message: 'Todos los campos son obligatorios');
      return;
    }

    Category category = new Category(name: name, description: description);
    ResponseApi? responseApi = await _categoriesProvider.createCategory(category);

    if (responseApi == null) {
      SnackbarHelper.show(
          context: context, message: 'Ocurrió un error inesperado');
      return;
    }

    SnackbarHelper.show(context: context, message: '${responseApi.message}');

    if (responseApi!.success) {
      nameController.text = '';
      descriptionController.text = '';
    }
  }

  void updateCategory(Category category) async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      SnackbarHelper.show(context: context, message: 'Todos los campos son obligatorios');
      return;
    }

    category.name = nameController.text;
    category.description = descriptionController.text;

    ResponseApi? responseApi = await _categoriesProvider.updateCategory(category);

    if (responseApi == null) {
      SnackbarHelper.show(context: context, message: 'Ocurrió un error inesperado');
      return;
    }

    SnackbarHelper.show(context: context, message: '${responseApi.message}');
  }

  void deleteCategory(int idCategory) async {
    bool confirmed = await _showConfirmDialog('Confirmación', '¿Querés eliminar esta categoría?');

    if (confirmed) {
      ResponseApi? responseApi = await _categoriesProvider.deleteCategory(idCategory as String);

      if (responseApi == null) {
        SnackbarHelper.show(context: context, message: 'Ocurrió un error inesperado');
        return;
      }

      SnackbarHelper.show(context: context, message: '${responseApi.message}');
    }
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      confirm = value ?? false;
    });

    return confirm;
  }
}
