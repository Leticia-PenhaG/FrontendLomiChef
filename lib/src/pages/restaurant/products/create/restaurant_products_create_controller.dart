import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  late PickedFile pickedFile;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

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

  /*para seleccionar la imagen de la cámara o de la galería*/
  Future<void> selectImage(ImageSource imageSource, int numberFile) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      if(numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        imageFile2 = File(pickedFile.path);
      }  else if (numberFile == 3) {
        imageFile3 = File(pickedFile.path);
      }
      //refresh();
    } // else {
    //  _showDialog('Error', 'No seleccionaste ninguna imagen.');
    //}
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('Galería'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('Cámara'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Seleccioná tu imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
