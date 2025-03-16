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
import 'package:path/path.dart';

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

    if (name.isEmpty || description.isEmpty || price==0) {
      SnackbarHelper.show(
          context: context, message: 'Todos los campos son obligatorios');
      return;
    }

    if(imageFile1 == null || imageFile2 == null || imageFile3 == null) {
      SnackbarHelper.show(context: context, message: 'Por favor, seleccioná todas las imágenes');
      return;
    }

    if(idCategory == '') {
      _showDialog('Error', 'Seleccioná la categoría del producto');
      return;
    }

    /*Product product = new Product(
        name: name,
        description: description,
        price: price,
        idCategory: int.tryParse(idCategory),
    );*/

    List<File> images = [];
    images.add(imageFile1!);
    images.add(imageFile2!);
    images.add(imageFile3!);

    print("Imágenes seleccionadas:");
    print("imageFile1: ${imageFile1!.path}");
    print("imageFile2: ${imageFile2!.path}");
    print("imageFile3: ${imageFile3!.path}");

    Product product = Product(
      name: name,
      description: description,
      price: price,
      idCategory: int.tryParse(idCategory),
      image1: basename(imageFile1!.path),
      image2: basename(imageFile2!.path),
      image3: basename(imageFile3!.path),
    );



    _progressDialog.show(max: 100, msg: 'Esperá un momento, procesando...');
    Stream stream = await _productsProvider.createProduct(product, images) as Stream;
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
      SnackbarHelper.show(context: context, message: responseApi.message);

      if(responseApi.success) {
        resetValues();
      }
    });

    print('Formulario Producto: ${product.toJson()}');
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

  /*para seleccionar la imagen de la cámara o de la galería forma original*/
  /*Future<void> selectImage(ImageSource imageSource, int numberFile) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      if(numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        imageFile2 = File(pickedFile.path);
      }  else if (numberFile == 3) {
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }*/

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
