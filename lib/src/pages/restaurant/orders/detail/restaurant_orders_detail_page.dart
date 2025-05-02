import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import 'package:lomi_chef_to_go/src/widgets/no_data_widget.dart';
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
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text('Orden #${_controller.order.id.isNotEmpty ? _controller.order.id : ''}')),
  //     bottomNavigationBar: _bottomBar(),
  //     body: _controller.selectedProducts.isNotEmpty
  //         ? ListView.builder(
  //             itemCount: _controller.selectedProducts.length,
  //             itemBuilder: (context, index) {
  //               return _cardProduct(_controller.selectedProducts[index]);
  //             },
  //           )
  //         : const NoDataWidget(text: 'Ningún producto fue agregado'),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${_controller.order.id}'),
        backgroundColor: Colors.deepOrange,
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
                  _infoRow('Cliente:', _controller.order.client?['name'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  _infoRow('Dirección:', _controller.order.address?['address'] ?? 'No especificada'),
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _controller.goToAddress,
          icon: const Icon(Icons.local_shipping, color: Colors.white),
          label: const Text(
            'DESPACHAR ORDEN',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }


  Widget _cardProduct(Product product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _imageProduct(product),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _addOrRemoveItem(product),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Text(
                  '${_controller.formatPrice(product.price! * product.quantity!)} Gs.',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.redAccent.shade200),
                  onPressed: () {
                    _controller.deleteItem(product);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        image: DecorationImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : const AssetImage('assets/img/no-image-icon.png')
                  as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _addOrRemoveItem(Product product) {
    return Row(
      children: [
        _quantityButton(Icons.remove, () {
          _controller.decreaseQuantity(product);
        }),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '${product.quantity}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        _quantityButton(Icons.add, () {
          _controller.increaseQuantity(product);
        }),
      ],
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: Colors.grey[400]),
          _textTotalPrice(),
          const SizedBox(height: 12),
          _buttonNext(),
        ],
      ),
    );
  }

  Widget _textTotalPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('${_controller.formatPrice(_controller.total)} Gs.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buttonNext() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: _controller.goToAddress,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          label: const Text(
            'Continuar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
