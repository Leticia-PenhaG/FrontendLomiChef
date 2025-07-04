import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import '../../../../models/product.dart';
import '../../../../models/user.dart';
import 'restaurant_orders_detail_controller.dart';
import '../../../../models/order.dart';
import 'package:timeago/timeago.dart' as timeago;

class RestaurantOrdersDetailPage extends StatefulWidget {
  Order order;
  RestaurantOrdersDetailPage({Key? key, required this.order});

  @override
  State<RestaurantOrdersDetailPage> createState() => _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState extends State<RestaurantOrdersDetailPage> {
  final RestaurantOrdersDetailController _controller = RestaurantOrdersDetailController();


  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('es', timeago.EsMessages());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_controller.order?.id}'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  // Text(
                  //   'Productos',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  _sectionTitle('Productos'),
                  const SizedBox(height: 8),
                  ...?_controller.selectedProducts.map((p) => _productTile(p)).toList() ?? [],
                  const Divider(height: 32),
                  _infoRow(
                    'Cliente:',
                    '${_controller.order?.client?['name'] ?? ''} ${_controller.order?.client?['lastname'] ?? ''}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Entregar en:', _controller.order?.address?['address'] ?? ''),
                  const SizedBox(height: 8),
                  //_infoRow('Fecha pedido:', _formatTimestamp(_controller.order!.timeStamp)),
                  _infoRow('Fecha pedido:', _formattedOrderTime(_controller.order!.timeStamp)),
                  const Divider(height: 32),
                  _infoRow(
                    'Total:',
                    '${_controller.formatPrice(_controller.total)} Gs.',
                    isBold: true,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 8),
  /*                _controller.order?.status == 'PAGADO' ? _dropDown(_controller.users) : Container(), //se listan usuarios repartidores
                  _controller.order?.status != 'PAGADO' ? _deliveryData() : Container(), //se listan usuarios repartidores
   */             _deliverySection(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _controller.order?.status == 'PAGADO'
          ? _buttonDespatch()
          : const SizedBox.shrink(),
    );
  }

  Widget _productTile(Product product) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.image1 ?? '',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset('assets/img/no-image-icon.png', width: 50, height: 50),
        ),
      ),
      title: Text(product.name ?? ''),
      subtitle: Text('Cantidad: ${product.quantity}'),
      trailing: Text(
        '${_controller.formatPrice(product.price! * product.quantity!)} Gs.',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _infoRow(String title, String value, {bool isBold = false, double fontSize = 16}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title ', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  //FECHA REAL
  // String _formattedOrderTime(int timestamp) {
  //   final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //   final now = DateTime.now();
  //   final difference = now.difference(date);
  //
  //   if (difference.inHours < 24) {
  //     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  //   } else {
  //     return timeago.format(date, locale: 'es');
  //   }
  // }

  //FECHA RELATIVA
  String _formattedOrderTime(int timestamp) {
    final orderDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    final isSameDay = orderDate.year == now.year &&
        orderDate.month == now.month &&
        orderDate.day == now.day;

    if (isSameDay) {
      // Mostrar fecha y hora si es del mismo día
      return '${orderDate.day}/${orderDate.month}/${orderDate.year} '
          '${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}';
    } else {
      // Mostrar tiempo relativo si es de otro día
      return timeago.format(orderDate, locale: 'es');
    }
  }

  Widget _deliverySection() {
    if (_controller.order?.status == 'PAGADO') {
      return _dropDown(_controller.users);
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Repartidor asignado'),
            const SizedBox(height: 10),
            _deliveryData(),
          ],
        ),
      );
    }
  }
//original
  Widget _dropDown(List<User> users) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _controller.order?.status == 'PAGADO' ? _sectionTitle('Asignar repartidor') : _sectionTitle('Repartidor asignado'),
          const SizedBox(height: 10),
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: users.isEmpty
                  ? Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(
                    'No hay repartidores disponibles',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
                  : DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text(
                    'Seleccioná un repartidor',
                    style: TextStyle(fontSize: 16),
                  ),
                  value: _controller.idDelivery, //id del courier seleccionado
                  items: _dropdownItems(users),
                  onChanged: (option) {
                    setState(() {
                      _controller.idDelivery = option!; //idDelivery es igual a la opción seleccionada
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropdownItems(List<User> users) {
    return users.map((user) {
      return DropdownMenuItem<String>(
        value: user.id,
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: user.image != null
                  ? NetworkImage(user.image!)
                  : AssetImage('assets/img/user.jpg') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(
              '${user.name} ${user.lastname ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _deliveryData() {
    final delivery = _controller.order?.delivery;
    final imageUrl = delivery?['image'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                ? NetworkImage(imageUrl)
                : const AssetImage('assets/img/user.jpg') as ImageProvider,
          ),
          const SizedBox(width: 10),
          Text(
            '${delivery?['name'] ?? ''} ${delivery?['lastname'] ?? ''}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 16),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      // decoration: BoxDecoration(
      //   color: AppColors.primaryColor.withOpacity(0.1),
      //   borderRadius: BorderRadius.circular(8),
      // ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }


  Widget _buttonDespatch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _controller.updateOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          child: const Text(
            'Procesar Orden',
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }


  void refresh() {
    setState(() {});
  }
}


