import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/provider/categories_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

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

    /*Category category = new Category (
      name: name,
      description: description

    );
    ResponseApi responseApi = await _categoriesProvider.createCategory(category);

    SnackbarHelper.show(context: context, message: ' ${responseApi.message}');

    if(responseApi.success) {
      nameController.text = '';
      descriptionController.text = '';
    }
*/
    print('Nombre: $name');
    print('Description: $description');
  }
}
