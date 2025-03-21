import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import 'dart:io';

import '../../../../models/category.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({super.key});

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {
  final ClientProductsListController _controllerClient = ClientProductsListController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
       await _controllerClient.init(context, refresh).then((_) {
         if (mounted) {
           setState(() {
             _isInitialized = true; // Cambia el estado una vez que `context` está listo
           });
         }
       });
    });
  }

  //     setState(() {
  //       _isInitialized = true; // Cambia el estado una vez que `context` está listo
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Se muestra un indicador de carga mientras el controlador se inicializa
      return DefaultTabController(
        length: _controllerClient.categories.length,
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Se construye la UI una vez que `context` está inicializado
    /*return Scaffold(
      key: _controllerClient.key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: AppBar(
          automaticallyImplyLeading: false,
          ///leading: ,
          backgroundColor: Colors.white,
          actions: [
            _shoppingBag()
          ],
          flexibleSpace: Column(
            children: [
              SizedBox(height: 70),
              _menuDrawer(),
              _textFieldSearch(),
              SizedBox(height: 20),
            ],
          ),
          bottom: TabBar(indicatorColor: AppColors.primaryColor,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey[400],
          isScrollable: true,
          tabs: List<Widget>.generate(_controllerClient.categories.length,(index){
            return Tab(
              child: Text(_controllerClient.categories[index].name ?? ''),
            );
          }),
        ),
      ),
      drawer: _drawer(),
      body: TabBarView(
          children: _controllerClient.categories.map((Category category){
            return Text('Hola');
          }).toList();
      ),
      ),
    ));*/
    return DefaultTabController(  // Faltaba envolver con DefaultTabController
      length: _controllerClient.categories.length,
      child: Scaffold(
        key: _controllerClient.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              _shoppingBag()
            ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 70),
                _menuDrawer(),
                _textFieldSearch(),
                SizedBox(height: 20),
              ],
            ),
            bottom: TabBar(
              indicatorColor: AppColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_controllerClient.categories.length, (index) {
                return Tab(
                  child: Text(_controllerClient.categories[index].name ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _controllerClient.categories.map((Category category) {
            return _cardProduct();
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardProduct() {
    return Container(
      height: 250,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          children: [
            Positioned(
                top: -1.0,
                right: -1.0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(20)
                    )
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _controllerClient.openDrawerBar,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  Color(0xff5cd0b3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: (_controllerClient.user.image != null && _controllerClient.user.image!.isNotEmpty)
                      ? NetworkImage(_controllerClient.user.image!) as ImageProvider
                      : const AssetImage('assets/img/no-image-icon.png'),
                ),
                const SizedBox(height: 10),

                Text(
                  '${_controllerClient.user.name ?? ''} ${_controllerClient.user.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerClient.user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerClient.user.phone ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Lista de opciones del Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.edit, 'Actualizar perfil', _controllerClient.goToUpdatePage),
                _buildDrawerItem(Icons.shopping_cart, 'Mis pedidos', () {}),

                //se controla que el usuario tenga más de un rol para mostrar la opción 'Seleccionar rol'
                if (_controllerClient.user != null &&
                    _controllerClient.user.roles!.length > 1)
                  _buildDrawerItem(
                    Icons.person,
                    'Seleccionar rol',
                    _controllerClient.goToRoles,
                  ) ,
                //const Divider(),

                _buildDrawerItem(Icons.power_settings_new, 'Cerrar sesión', () {
                  _controllerClient.logout();
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Función para construir ListTiles de manera más reutilizable
  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap,
      {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
      onTap: onTap,
    );
  }

  void refresh(){
    setState(() {

    });
  }

  Widget _shoppingBag(){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.shopping_bag_outlined,
            color: Colors.black,
          ),
        ),
        Positioned(
          right: 16,
          child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
        ))
      ],
    );
  }

  Widget _textFieldSearch() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar',
          suffixIcon: Icon(
              Icons.search_rounded,
            color: Colors.grey[400]
          ),
          hintStyle: TextStyle(
            fontSize: 17,
            color: Colors.grey[500]
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(
              color: Colors.grey
            )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                  color: Colors.grey
              )
          ),
          contentPadding: EdgeInsets.all(15)
        ),
      ),
    );
  }

/*Widget _drawer() {
    return Drawer (
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primaryColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, //izq.
                children: [
                  Text('Nombre de usuario',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,
                  ),
                  Text('Email',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Text('Teléfono',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,
                  ),
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top: 8),
                    child: FadeInImage(
                        image: AssetImage('assets/img/no-image-icon.png'),
                        fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder: AssetImage('assets/img/no-image.png'),
                    ),
                  )
                ]
              )
          ),
          ListTile(
            title: Text('Actualizar perfil'),
            trailing: Icon(Icons.edit)
          ),
          ListTile(
              title: Text('Mis pedidos'),
              trailing: Icon(Icons.shopping_cart)
          ),
          ListTile(
              title: Text('Seleccionar rol'),
              trailing: Icon(Icons.person)
          ),
          ListTile(
              onTap: _controllerClient.logout,
              title: Text('Cerrar sesión'),
              trailing: Icon(Icons.power_settings_new)
          ),
        ],
      ),
    );
  }*/
}
