import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_controlller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({super.key});

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  final ClientProductsListController _controllerProductList =
      ClientProductsListController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _controllerProductList.init(context);
      setState(() {
        _isInitialized =
            true; // Cambia el estado una vez que `context` está listo
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Se muestra un indicador de carga mientras el controlador se inicializa
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Se construye la UI una vez que `context` está inicializado
    return Scaffold(
      key: _controllerProductList.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _controllerProductList.logout(),
          child: const Text('Cerrar sesión'),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _controllerProductList.openDrawerNavigator,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset(
          'assets/img/menu.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryColor),
              child: Column(children: [
                Text(
                  'Nombre de usuario',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                )
              ])),
        ],
      ),
    );
  }
}
