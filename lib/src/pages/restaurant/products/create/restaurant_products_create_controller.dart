import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/provider/categories_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../../../../models/user.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../models/category.dart';

class RestaurantProductsCreateController {
  late final BuildContext context;
  late Function refresh;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  //final MoneyMaskedTextController priceController = MoneyMaskedTextController();

  final CategoriesProvider _categoriesProvider = CategoriesProvider();

  late User user;
  SharedPreferencesHelper sharedPref = new SharedPreferencesHelper();

  List<Category> categories = [];
  late String idCategory = ''; //almacena el id de la categoría seleccionada


  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.readSessionToken('user'));
    _categoriesProvider.init(context, user);
    getCategories();
  }

  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    print("Categorías obtenidas en frontend: ${categories.map((c) => c.name).toList()}");
    refresh();
  }

  void createProduct() async {
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isEmpty || description.isEmpty) {
      SnackbarHelper.show(
          context: context, message: 'Todos los campos son obligatorios');
      return;
    }
  }
}
