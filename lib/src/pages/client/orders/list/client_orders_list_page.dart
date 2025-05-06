import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../models/order.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({super.key});

  @override
  State<ClientOrdersListPage> createState() => _ClientOrdersListPageState();
}

class _ClientOrdersListPageState extends State<ClientOrdersListPage> {

  final ClientOrdersListController _controllerRestaurant = ClientOrdersListController();
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
            title: Text('Mis pedidos'),
            automaticallyImplyLeading: true,
            backgroundColor: AppColors.primaryColor,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 70),
                // _menuDrawer() eliminado
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
        //drawer: _drawer(),
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
    return GestureDetector(
      onTap: () {
        _controllerRestaurant.openBottomSheet(order!); //se abre el detalle de la orden
      },
      child: Container(
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
                      'Pedido: ${_formatTimestamp(order?.timeStamp ?? 0)}',
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
                        //'Cliente: ${order?.client?.name ?? ""}',
                        //'Cliente: "Leti"',
                        'Cliente: ${order?.client?['name'] ?? ''} ${order?.client?['lastname'] ?? ''}',
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
                        //'Entregar en: ${order?.address?.address ?? ""}',
                        //'Entregar en: "Dirección"',
                        'Entregar en: ${order?.address?['address'] ?? ''} - ${order?.address?['neighborhood'] ?? ''}',
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
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    try {
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
    } catch (e) {
      return '';
    }
  }

  void refresh(){
    setState(() {

    });
  }
}
