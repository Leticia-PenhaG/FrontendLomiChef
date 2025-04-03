import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_controller.dart';

import '../../../../models/product.dart';
import 'client_orders_create_controller.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({super.key});

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {

  ClientsOrdersCreateController _controller = new ClientsOrdersCreateController();

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
      body: Center(child: Text('Order')),
    );
  }

  Widget _cardProduct(Product product) {
    return Container(
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            child: FadeInImage(
              image: product.image1 != null
                  ? NetworkImage(product.image1!)
                  : AssetImage('assets/img/no-image-icon.png') as ImageProvider,
              fit: BoxFit.contain,
              placeholder: AssetImage('assets/img/no-image-icon.png'),
              fadeInDuration: Duration(milliseconds: 50),
            ),
      )
      ],
      ),
    );
  }

  void refresh(){
    setState(() {
    });
  }
}
