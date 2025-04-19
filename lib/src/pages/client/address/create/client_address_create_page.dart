import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({super.key});

  @override
  State<ClientAddressCreatePage> createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  final ClientAddressListController _controller = ClientAddressListController();

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
              _buildInputField(
                label: 'Punto de referencia',
                hint: 'Dejá algún punto de referencia',
                icon: Icons.map,
              ),
              const SizedBox(height: 40),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
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
    return SizedBox(
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
    );
  }

  void refresh() {
    setState(() {});
  }
}
