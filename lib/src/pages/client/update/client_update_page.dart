import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../utils/app_colors.dart';
import 'client_update_controller.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({super.key});

  @override
  State<ClientUpdatePage> createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {
  final ClientUpdateController _controllerClientUpdate = ClientUpdateController();
  final _formKey = GlobalKey<FormState>(); // Clave para validar formulario

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controllerClientUpdate.init(context, refresh);
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
          'Actualizar perfil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Center(child: _imageUser()),
                const SizedBox(height: 24),

                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerClientUpdate.nameController,
                  label: 'Nombre',
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? 'El nombre es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerClientUpdate.lastNameController,
                  label: 'Apellido',
                  icon: Icons.person,
                  validator: (value) => value == null || value.isEmpty
                      ? 'El apellido es obligatorio'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _controllerClientUpdate.phoneController,
                  label: 'Teléfono',
                  icon: Icons.phone,
                  inputType: TextInputType.phone,
                  validator: (value) => _controllerClientUpdate.validatePhone(value),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _controllerClientUpdate.isBtnUpdateEnabled
                ? () {
              if (_formKey.currentState!.validate()) {
                _controllerClientUpdate.updateProfile();
              }
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff38c2a6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Actualizar perfil',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageUser() {
    return GestureDetector(
      onTap: _controllerClientUpdate.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _controllerClientUpdate.imageFile != null
            ? FileImage(_controllerClientUpdate.imageFile!)
            : const AssetImage('assets/img/client.png'),
        radius: 70,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

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
        errorStyle: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
      ),
      validator: validator,
    );
  }

  void refresh() {
    setState(() {});
  }
}
