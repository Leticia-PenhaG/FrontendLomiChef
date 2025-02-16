import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../models/user.dart';
import '../../../provider/user_provider.dart';

class ClientUpdateController {
  late final BuildContext context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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

    // Recuperar el usuario desde SharedPreferences
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));

    // Asignar los valores recuperados
    nameController.text = user.name;
    lastNameController.text = user.lastname;
    phoneController.text = user.phone ?? '';
    emailController.text = user.email ?? '';

    // Recuperar la contraseña, si existe
    if (user.password != null && user.password!.isNotEmpty) {
      passwordController.text = user.password!;
      confirmPasswordController.text = user.password!;
    } else {
      passwordController.text = ''; // Si no hay contraseña guardada, se deja el campo vacío
      confirmPasswordController.text = '';
    }

    refresh();
  }

  //permite actualizar perfil del cliente
  void updateProfile() async {
    _progressDialog.show(max: 100, msg: 'Procesando...');
    isBtnUpdateEnabled = false;
    refresh();

    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    // Si la contraseña está vacía, no la enviamos (el backend la ignora)
    User actualUser = User(
        id: user.id,
        email: email,
        name: name,
        lastname: lastName,
        phone: phone,
        password: password.isNotEmpty ? password : null, // Si está vacía, no se manda
        image: user.image // Mantiene la imagen actual si no se selecciona una nueva
    );

    Stream<dynamic>? tempStream;

    if (imageFile != null) {
      tempStream = await usersProvider.updateProfile(actualUser, imageFile!);
    } else {
      tempStream = await usersProvider.updateProfile(actualUser, null);
    }

    if (tempStream == null) {
      _showDialog('Error', 'No se pudo completar la actualización. Intentá de nuevo.');
      isBtnUpdateEnabled = true;
      refresh();
      return;
    }

    tempStream.listen((res) async {
      _progressDialog.close();
      ResponseApi? responseApi = ResponseApi.fromJson(json.decode(res));
      Fluttertoast.showToast(msg: responseApi.message);

      if (responseApi != null && responseApi.success == true) {
        //user = (await usersProvider.getUserById(actualUser.id))!; //se obtiene el cliente de la base de datos

        if (actualUser.id != null) {
          user = await usersProvider.getUserById(actualUser.id!) ?? user;
        }

        _sharedPreferencesHelper.saveSessionToken('user', user.toJson());

        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
      } else {
        _showDialog('Error', responseApi?.message ?? 'Ocurrió un error inesperado');
        isBtnUpdateEnabled = true;
        refresh();
      }
    });
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    const emailRegex = r'^[^@]+@[^@]+\.[^@]+$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Se mantiene la contraseña actual si es que no se ingresa una nueva
    }
    const passwordRegex =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Debe tener: \n- Al menos 8 caracteres\n- Una mayúscula\n- Una minúscula\n- Un número\n- Un carácter especial.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (passwordController.text.isNotEmpty && value != passwordController.text.trim()) {
      return 'Las contraseñas no coinciden';
    }
    return null;
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
