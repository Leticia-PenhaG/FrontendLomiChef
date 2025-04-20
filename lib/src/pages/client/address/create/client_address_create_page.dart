import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

import 'client_address_create_controller.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({super.key});

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  final ClientAddressCreateController _controller = ClientAddressCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva dirección'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Completá estos datos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildInputField(
                label: 'Dirección',
                hint: 'Ingresá tu dirección',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Barrio',
                hint: '',
                icon: Icons.location_city,
              ),
              const SizedBox(height: 20),
              /*_buildInputField(
                label: 'Punto de referencia',
                hint: 'Dejá algún punto de referencia',
                icon: Icons.map,
              ),*/
              _textFieldRefPoint(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCreateButton(),
    );
  }

  Widget _buildInputField({required String label, required String hint, required IconData icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.primaryColor),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            // Acción de creación
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'CREAR DIRECCIÓN',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldRefPoint() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        onTap: _controller.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
          labelText: 'Punto de referencia',
          suffixIcon: Icon(
            Icons.map,
            color: AppColors.primaryColor,
          )
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}