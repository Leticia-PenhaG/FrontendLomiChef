import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import '../../../../models/product.dart';
import 'restaurant_orders_detail_controller.dart';
import '../../../../models/order.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh, widget.order);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_controller.order.id}'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Text(
                    'Productos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._controller.selectedProducts.map((p) => _productTile(p)).toList(),
                  const Divider(height: 32),
                  _infoRow(
                    'Cliente:',
                    '${_controller.order.client?['name'] ?? ''} ${_controller.order.client?['lastname'] ?? ''}',
                  ),
                  const SizedBox(height: 8),
                  _infoRow('Entregar en:', _controller.order.address?['address'] ?? ''),
                  const SizedBox(height: 8),
                  _infoRow('Fecha pedido:', _formatTimestamp(_controller.order.timeStamp)),
                  const Divider(height: 32),
                  _infoRow(
                    'Total:',
                    '${_controller.formatPrice(_controller.total)} Gs.',
                    isBold: true,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buttonDespatch(),
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

  Widget _buttonDespatch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _controller.goToAddress,
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
