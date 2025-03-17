import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/provider/categories_provider.dart';
import 'package:lomi_chef_to_go/src/provider/products_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/snackbar_helper.dart';
import '../../../../models/category.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RestaurantProductsCreateController {
  late final BuildContext context;
  late Function refresh;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final MoneyMaskedTextController priceController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'Gs. ',
  );

  final CategoriesProvider _categoriesProvider = CategoriesProvider();
  final ProductsProvider _productsProvider = ProductsProvider();

  late User user;
  SharedPreferencesHelper sharedPref = new SharedPreferencesHelper();

  List<Category> categories = [];
  late String idCategory = ''; //almacena el id de la categoría seleccionada

  //Imágenes
  late PickedFile pickedFile;
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  late ProgressDialog _progressDialog;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await sharedPref.readSessionToken('user'));
    _categoriesProvider.init(context, user);
    _productsProvider.init(context, user);
    _progressDialog = ProgressDialog(context: context);

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
    double price = priceController.numberValue;

    if (name.isEmpty || description.isEmpty || price == 0) {
      SnackbarHelper.show(context: context, message: 'Todos los campos son obligatorios');
      return;
    }

    if (imageFile1 == null || imageFile2 == null || imageFile3 == null) {
      SnackbarHelper.show(context: context, message: 'Seleccioná las 3 imágenes');
      return;
    }

    if (idCategory == '') {
      _showDialog('Error', 'Seleccioná la categoría del producto');
      return;
    }

    List<File> images = [imageFile1!, imageFile2!, imageFile3!];

    Product product = Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.tryParse(idCategory),
    );

    _progressDialog.show(max: 100, msg: 'Esperá un momento, procesando...');

    try {
      var response = await _productsProvider.createProduct(product, images);

      if (response!.statusCode == 201) {
        var responseBody = jsonDecode(await response.stream.bytesToString());
        ResponseApi responseApi = ResponseApi.fromJson(responseBody);

        _progressDialog.close();
        SnackbarHelper.show(context: context, message: responseApi.message);

        if (responseApi.success) {
          resetValues();
        }
      } else {
        var errorBody = jsonDecode(await response.stream.bytesToString());
        _progressDialog.close();
        SnackbarHelper.show(context: context, message: 'Error: ${errorBody['message']}');
      }
    } catch (e) {
      _progressDialog.close();
      SnackbarHelper.show(context: context, message: 'Error al crear el producto');
      print('Error en createProduct: $e');
    }
  }

  void resetValues() {
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '0.0';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory = '';
    refresh();

  }

  Future<void> selectImage(ImageSource imageSource, int numberFile) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      print("Imagen seleccionada ($numberFile): ${selectedImage.path}");

      if (numberFile == 1) {
        imageFile1 = selectedImage;
      } else if (numberFile == 2) {
        imageFile2 = selectedImage;
      } else if (numberFile == 3) {
        imageFile3 = selectedImage;
      }
    } else {
      print("No se seleccionó imagen ($numberFile)");
    }

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

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
