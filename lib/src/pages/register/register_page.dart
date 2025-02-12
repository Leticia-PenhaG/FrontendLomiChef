import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/register/register_controller.dart';

import '../../utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controllerRegister = RegisterController();

  final _formKey =
      GlobalKey<FormState>(); // Clave del formulario para la validación

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controllerRegister.init(context); // Inicializar controladores
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registro',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Asignar clave al formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                /*const Text(
                  'Creá tu cuenta',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff38c2a6)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresá la información necesaria para completar tu registro.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),*/
                Center(child: _imageUser()),
                const SizedBox(height: 24),
                // Campos de texto
                _buildTextField(
                  controller: _controllerRegister.emailController,
                  label: 'Correo Electrónico',
                  icon: Icons.email,
                  validator: (value) =>
                      _controllerRegister.validateEmail(value),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerRegister.nameController,
                  label: 'Nombre',
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? 'El nombre es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerRegister.lastNameController,
                  label: 'Apellido',
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? 'El apellido es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerRegister.phoneController,
                  label: 'Teléfono',
                  icon: Icons.phone,
                  inputType: TextInputType.phone,
                  validator: (value) =>
                      _controllerRegister.validatePhone(value),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerRegister.passwordController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) =>
                      _controllerRegister.validatePassword(value),
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerRegister.confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  icon: Icons.lock,
                  isPassword: true,
                  validator: (value) =>
                      _controllerRegister.validateConfirmPassword(value),
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _controllerRegister.register();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff38c2a6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _controllerRegister.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/img/client.png'),
        radius: 70,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  // Método para construir un TextField personalizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff38c2a6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorStyle: const TextStyle(
          fontSize: 14,
          overflow: TextOverflow.ellipsis, // Controla el desbordamiento
        ),
      ),
      validator: validator,
    );
  }
}
