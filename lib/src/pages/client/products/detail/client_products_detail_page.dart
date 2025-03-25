import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
          _imageSlideshow(),
          _textName(),
          _textDescription(),
          _addRemoveItem()
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
      autoPlayInterval: 3000,
      isLoop: true,
      onPageChanged: (value) {
        debugPrint('Page changed: $value');
      },
      children: [
        FadeInImage(
          image: (_controllerProductsDetail.product?.image1 != null)
              ? NetworkImage(_controllerProductsDetail.product!.image1!)
              : AssetImage('assets/img/burger.png') as ImageProvider,  // Se asegura de que sea un ImageProvider
          fit: BoxFit.contain,
          placeholder: AssetImage('assets/img/no-image-icon.png'),
          fadeInDuration: Duration(milliseconds: 50),
        ),
        FadeInImage(
          image: (_controllerProductsDetail.product?.image2 != null)
              ? NetworkImage(_controllerProductsDetail.product!.image2!)
              : AssetImage('assets/img/burger.png') as ImageProvider,
          fit: BoxFit.contain,
          placeholder: AssetImage('assets/img/no-image-icon.png'),
          fadeInDuration: Duration(milliseconds: 50),
        ),
        FadeInImage(
          image: (_controllerProductsDetail.product?.image3 != null)
              ? NetworkImage(_controllerProductsDetail.product!.image3!)
              : AssetImage('assets/img/burger.png') as ImageProvider,
          fit: BoxFit.contain,
          placeholder: AssetImage('assets/img/no-image-icon.png'),
          fadeInDuration: Duration(milliseconds: 50),
        ),
      ],
    );
  }

  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text (
        _controllerProductsDetail.product?.name ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 15),
      child: Text(
        _controllerProductsDetail.product?.description ?? '',
        style: TextStyle(
            fontSize: 13,
            color: Colors.blueGrey
        ),
      ),
    );
  }

  Widget _addRemoveItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row (
        children: [
          IconButton(
              onPressed: () {} ,
              icon: Icon(
                Icons.add_circle_outline_outlined,
                color: Colors.grey,
                size: 30,
              )
          ),

          Text(
            '1',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey
            ),
          ),

          IconButton(
              onPressed: () {} ,
              icon: Icon(
                Icons.remove_circle_outline_outlined,
                color: Colors.grey,
                size: 30,
              )
          ),
          Spacer(), //alinea a la derecha
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Text(
              '${_controllerProductsDetail.product?.price ?? 0} Gs.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
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
