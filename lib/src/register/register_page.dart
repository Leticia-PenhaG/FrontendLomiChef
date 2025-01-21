import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controladores para los campos de texto
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Text(
                'Creá tu cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff38c2a6)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Por favor, ingresá la información necesaria para completar tu registro.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Campos de texto
              _buildTextField(controller: emailController, label: 'Correo Electrónico', icon: Icons.email),
              const SizedBox(height: 16),
              _buildTextField(controller: nameController, label: 'Nombre', icon: Icons.person),
              const SizedBox(height: 16),
              _buildTextField(controller: lastNameController, label: 'Apellido', icon: Icons.person),
              const SizedBox(height: 16),
              _buildTextField(controller: phoneController, label: 'Teléfono', icon: Icons.phone, inputType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(controller: passwordController, label: 'Contraseña', icon: Icons.lock, isPassword: true),
              const SizedBox(height: 16),
              _buildTextField(controller: confirmPasswordController, label: 'Confirmar Contraseña', icon: Icons.lock, isPassword: true),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO
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
    );
  }

  // Método para construir un TextField personalizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xff38c2a6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}