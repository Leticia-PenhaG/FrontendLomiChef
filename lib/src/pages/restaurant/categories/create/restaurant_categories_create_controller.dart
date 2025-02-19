import 'package:flutter/material.dart';

import '../../../../utils/snackbar_helper.dart';

class RestaurantCategoriesCreateController {
  late final BuildContext context;
  late Function refresh;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
  }

  void createCategory() {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      SnackbarHelper.show(
          context: context, message: 'Todos los campos son obligatorios');
      return;
    }

    print('Nombre: $name');
    print('Description: $description');
  }
}
