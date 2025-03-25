import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:lomi_chef_to_go/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

import '../../../../models/product.dart';
import 'client_product_detail_controller.dart';

class ClientProductsDetailPage extends StatefulWidget {

  Product product;

  ClientProductsDetailPage({Key? key, required this.product}) : super (key:key);

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {
  final ClientProductDetailController _controllerProductsDetail = ClientProductDetailController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _imageSlideshow()
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      _controllerProductsDetail.init(context, refresh, widget.product!);
    });
  }

  Widget _imageSlideshow() {
     return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      initialPage: 0,
      indicatorColor: AppColors.primaryColor,
      indicatorBackgroundColor: Colors.grey,
      onPageChanged: (value) {
        debugPrint('Page changed: $value');
      },
      autoPlayInterval: 3000,
      isLoop: true,
      children: [
     FadeInImage(
       image: (_controllerProductsDetail.product?.image1 != null)
           ? NetworkImage(_controllerProductsDetail.product!.image1!)
           : const AssetImage('assets/img/burger.png') as ImageProvider,
    fit: BoxFit.contain,
    placeholder: AssetImage('assets/img/no-image-icon.png'),
    fadeInDuration: Duration(milliseconds: 50),
    ),
        Image.asset(
          'images/sample_image_2.jpg',
          fit: BoxFit.cover,
        ),
        Image.asset(
          'images/sample_image_3.jpg',
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
