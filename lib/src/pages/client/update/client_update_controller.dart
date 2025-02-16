import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../models/user.dart';
import '../../../provider/user_provider.dart';

class ClientUpdateController {
  late final BuildContext context;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  UserProvider usersProvider = UserProvider();
  XFile? pickedFile;
  File? imageFile;
  late Function refresh;
  late ProgressDialog _progressDialog;
  bool isBtnUpdateEnabled = true;
  late User user;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    await Future.delayed(Duration.zero);
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    nameController.text = user.name;
    lastNameController.text = user.lastname;
    phoneController.text = user.phone!;
    refresh();
  }

  void updateProfile() async {
    if (imageFile == null) {
      _showDialog('Error', 'Por favor seleccioná una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Procesando...');
    isBtnUpdateEnabled = false;
    refresh();

    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();

    User user = User(
      name: name,
      lastname: lastName,
      phone: phone,
    );

    Stream<dynamic>? tempStream = await usersProvider.createWithImage(user, imageFile!);

    if (tempStream == null) {
      _showDialog('Error', 'No se pudo completar el registro. Intentá de nuevo.');
      isBtnUpdateEnabled = true;
      refresh();
      return;
    }

    Stream<dynamic> stream = tempStream; // para asegurar que no sea null

    stream.listen((res) {
      _progressDialog.close();
      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res)); // Respuesta del servicio

      if (responseApi != null && responseApi.success == true) {
        Future.delayed(Duration(seconds: 3), () {    //si el registro fue exitoso se redirige al login automáticamente después de 3 segundos
          Navigator.pushReplacementNamed(context, 'login');
        });
        _showDialog('Éxito',
            'Usuario registrado correctamente, ahora podés iniciar sesión');
      } else {
        _showDialog(
            'Error', responseApi?.message ?? 'Ocurrió un error inesperado');
        isBtnUpdateEnabled = true;
        refresh();
      }
    });
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }
    return null;
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

  /*para seleccionar la imagen de la cámara o de la galería*/
  Future<void> selectImage(ImageSource imageSource) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      refresh();
    } else {
      _showDialog('Error', 'No seleccionaste ninguna imagen.');
    }

    Navigator.pop(context);
  }

  void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery);
        },
        child: Text('Galería'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
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
