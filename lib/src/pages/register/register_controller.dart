import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';

class RegisterController {
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
  bool isBtnRegisterEnabled = true;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    await Future.delayed(Duration.zero);
    usersProvider.init(context);
    _progressDialog = ProgressDialog(context: context);
  }

  void register() async {
    if (imageFile == null) {
      _showDialog('Error', 'Por favor seleccioná una imagen');
      return;
    }

    _progressDialog.show(max: 100, msg: 'Procesando...');
    isBtnRegisterEnabled = false;
    refresh();

    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    User user = User(
      email: email,
      name: name,
      lastname: lastName,
      phone: phone,
      password: password,
    );

    Stream<dynamic>? tempStream = await usersProvider.createWithImage(user, imageFile!);

    if (tempStream == null) {
      _showDialog('Error', 'No se pudo completar el registro. Intentá de nuevo.');
      isBtnRegisterEnabled = true;
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
        isBtnRegisterEnabled = true;
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
      return 'La contraseña es obligatoria';
    }
    const passwordRegex =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Debe tener: \n- Al menos 8 caracteres\n- Una mayúscula\n- Una minúscula\n- Un número\n- Un carácter especial.';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El teléfono es obligatorio';
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value)) {
      return 'Nº inválido (debe tener mínimo 9 caracteres)';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña no puede ser vacía ni nula';
    }
    if (value != passwordController.text.trim()) {
      return 'Las contraseñas no coinciden';
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
