import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../models/order.dart';


class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({super.key});

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPageState();
}

class _RestaurantOrdersListPageState extends State<RestaurantOrdersListPage> {

  final RestaurantOrdersListController _controllerRestaurant = RestaurantOrdersListController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _controllerRestaurant.init(context, refresh);
      setState(() {
        _isInitialized = true; // Cambia el estado una vez que `context` está listo
      });
    });
  }

  Widget build(BuildContext context) {
    if (!_isInitialized) {
      // Se muestra un indicador de carga mientras el controlador se inicializa
      return DefaultTabController(
        length: _controllerRestaurant.categories.length,
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: _controllerRestaurant.categories.length,
      child: Scaffold(
        key: _controllerRestaurant.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            // actions: [
            //   _shoppingBag()
            // ],
            flexibleSpace: Column(
              children: [
                SizedBox(height: 70),
                _menuDrawer(),
                SizedBox(height: 15),
              ],
            ),
            bottom: TabBar(
              indicatorColor: AppColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_controllerRestaurant.categories.length, (index) {
                return Tab(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      _controllerRestaurant.categories[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _controllerRestaurant.categories.map((String category) {
            return _cardOrder(null);
            // return FutureBuilder(
            //     future: _controllerRestaurant.getProducts(category.id!),
            //     builder:(context, AsyncSnapshot<List<Product>> snapshot) {
            //
            //       if(snapshot.hasData) {
            //         if(snapshot.data!.isNotEmpty ) {
            //           //son los card de los productos que se muestran
            //           return GridView.builder(
            //               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //                   crossAxisCount: 2,
            //                   childAspectRatio:0.7
            //               ) ,
            //               itemCount: snapshot.data?.length ?? 0,
            //               itemBuilder: (_, index) {
            //                 return _cardProduct(snapshot.data![index]);
            //               }
            //           );
            //         }
            //         else {
            //           return NoDataWidget(text: 'No hay productos en esta categoría');
            //         }
            //       } else {
            //         return NoDataWidget(text: 'No hay productos en esta categoría');
            //       }
            //     }
            // );
          }).toList(),
        ),
      ),
    );
  }

  Widget _menuDrawer() {
    return GestureDetector(
      onTap: _controllerRestaurant.openDrawerBar,
      child: Container (
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20,),
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
                  backgroundImage: (_controllerRestaurant.user.image != null && _controllerRestaurant.user.image!.isNotEmpty)
                      ? NetworkImage(_controllerRestaurant.user.image!) as ImageProvider
                      : const AssetImage('assets/img/no-image-icon.png'),
                ),
                const SizedBox(height: 10),

                Text(
                  '${_controllerRestaurant.user.name ?? ''} ${_controllerRestaurant.user.lastname ?? ''}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerRestaurant.user.email ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  _controllerRestaurant.user.phone ?? '',
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
                if (_controllerRestaurant.user != null &&
                    _controllerRestaurant.user.roles!.length > 1)

                  _buildDrawerItem(
                    Icons.list_alt_outlined,
                    'Crear categoría',
                    _controllerRestaurant.goToCategoriesCreate,
                  ) ,

                _buildDrawerItem(
                  Icons.local_pizza,
                  'Crear producto',
                  _controllerRestaurant.goToProductsCreate,
                ) ,

                  _buildDrawerItem(
                    Icons.person,
                    'Seleccionar rol',
                    _controllerRestaurant.goToRoles,
                  ) ,

                //const Divider(),

                _buildDrawerItem(Icons.power_settings_new, 'Cerrar sesión', () {
                  _controllerRestaurant.logout();
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Función para construir ListTiles de manera más reutilizable
  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(fontSize: 16, color: color),
      ),
      onTap: onTap,
    );
  }

  Widget _cardOrder(Order? order) {
    return Container(
     height: 160,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)
                    )
                  ),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                        'Orden#1',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                    Text(
                      'Pedido:15-03-2025',
                      style: TextStyle(
                        fontSize: 13
                      ),
                    ),
                  Text(
                    'Cliente:Leti',
                    style: TextStyle(
                        fontSize: 13
                    ),
                    maxLines: 1,
                  ),
                  Text(
                    'Entregar en:Dirección',
                    style: TextStyle(
                        fontSize: 13
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void refresh(){
    setState(() {

    });
  }
}
