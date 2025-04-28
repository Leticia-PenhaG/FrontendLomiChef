import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../models/order.dart';
import '../../../../widgets/no_data_widget.dart';


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
        length: _controllerRestaurant.status.length,
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return DefaultTabController(
      length: _controllerRestaurant.status.length,
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
              tabs: List<Widget>.generate(_controllerRestaurant.status.length, (index) {
                return Tab(
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      _controllerRestaurant.status[index],
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
          children: _controllerRestaurant.status.map((String status) {
            //return _cardOrder(null);
            return FutureBuilder(
                future: _controllerRestaurant.getOrders(status),
                builder:(context, AsyncSnapshot<List<Order>> snapshot) {

                  if(snapshot.hasData) {
                    if(snapshot.data!.isNotEmpty ) {
                      //son los card de los productos que se muestran
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data![index]);
                          }
                      );
                    }
                    else {
                      return NoDataWidget(text: 'No hay órdenes');
                    }
                  } else {
                    return NoDataWidget(text: 'No hay órdenes');
                  }
                }
            );
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
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        shadowColor: AppColors.primaryColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Número de orden
              Row(
                children: [
                  Icon(Icons.receipt_long, color: AppColors.primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    'Orden #${order?.id ?? "1"}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Fecha del pedido
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    //'Pedido: ${order?.timestamp ?? "15-03-2025"}',
                    'Pedido: "15-03-2025"',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Nombre del cliente
              Row(
                children: [
                  Icon(Icons.person, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      //'Cliente: ${order?.client?.name ?? "Leti"}',
                      'Cliente: "Leti"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Dirección de entrega
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      //'Entregar en: ${order?.address?.address ?? "Dirección"}',
                      'Entregar en: "Dirección"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
