import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';
import 'package:lomi_chef_to_go/src/widgets/no_data_widget.dart';
import '../../../../models/product.dart';
import 'client_orders_create_controller.dart';

//diseño original
/*class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({super.key});

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {
  ClientsOrdersCreateController _controller =
      new ClientsOrdersCreateController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi orden'),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.235,
        child: Column(
          children: [
            Divider(
              color: Colors.grey[400],
              endIndent: 30, //para definir margen derecha
              indent: 30 //margen en la izquierda,
            ),
            _textTotalPrice(),
            _buttonNext()
          ],
        ),
      ),
      body: _controller.selectedProducts.isNotEmpty
          ? ListView(
              children: _controller.selectedProducts.map((Product product) {
                return _cardProduct(product);
              }).toList(),
            )
          : NoDataWidget(
              text: 'Ningún producto fue agregado',
            ),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 10),
          Column(
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _addOrRemoveItem(product)
            ],
          ),
          Spacer(),
          Column(
            children: [
              _textPrice(product),
              _iconDelete(product)
            ],
          )
        ],
      ),
    );
  }

  Widget _iconDelete(Product product) {
    return IconButton(
        onPressed: () {},
        icon: Icon(Icons.delete, color: AppColors.primaryColor,)
    );
  }

  Widget _textPrice(Product product) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
          '${product.price! * product.quantity!}',
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return Container(
      width: 90,
      height: 90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.grey[200]),
      child: FadeInImage(
        image: product.image1 != null
            ? NetworkImage(product.image1!)
            : AssetImage('assets/img/no-image-icon.png') as ImageProvider,
        fit: BoxFit.contain,
        placeholder: AssetImage('assets/img/no-image-icon.png'),
        fadeInDuration: Duration(milliseconds: 50),
      ),
    );
  }

  Widget _addOrRemoveItem(Product product){
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8)
            ),
            color: Colors.grey[200],
          ),
          child: Text('-'),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.grey[200],
          child: Text('${product?.quantity ?? 0}'),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8)
            ),
            color: Colors.grey[200],
          ),
          child: Text('+'),
        ),
      ],
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),
          ),
          Text(
            '0\Gs.',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          )
        ],
      ),
    );
  }


  Widget _buttonNext() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.greenAccent, size: 30,),
          SizedBox(width: 8),
          Text('Continuar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}*/

//primera opción
class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({super.key});

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {
  final ClientsOrdersCreateController _controller = ClientsOrdersCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi orden')),
      bottomNavigationBar: _bottomBar(),
      body: _controller.selectedProducts.isNotEmpty
          ? ListView.builder(
        itemCount: _controller.selectedProducts.length,
        itemBuilder: (context, index) {
          return _cardProduct(_controller.selectedProducts[index]);
        },
      )
          : const NoDataWidget(text: 'Ningún producto fue agregado'),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _addOrRemoveItem(product),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${(product.price! * product.quantity!).toInt()} Gs.',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
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
              : const AssetImage('assets/img/no-image-icon.png') as ImageProvider,
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
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
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
        Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text('${_controller.total.toInt()} Gs.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buttonNext() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text('Continuar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

