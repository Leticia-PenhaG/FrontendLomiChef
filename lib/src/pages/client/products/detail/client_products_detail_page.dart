import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

import '../../../../models/product.dart';
import 'client_product_detail_controller.dart';

/* Versión 1

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
          Spacer(),
          _addRemoveItem(),
          _deliveryUi(),
          _buttonShoppingBag()
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
    return Stack(
      children: [
        ImageSlideshow(
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
        ),
        Positioned(
          left: 10,
          top: 5,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            color: AppColors.primaryColor,
          ),
        )
      ],
    );
  }

  Widget _textName() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 30, left: 30, top: 30),
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

  Widget _deliveryUi() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/img/delivery.png',
            height: 45
          ),
          SizedBox(width: 7),
          Text(
            'Cobro por delivery',
            style: TextStyle(
              fontSize: 20,
              color: Colors.green
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonShoppingBag() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30 ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                    'Agregar al carrito',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 35,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ), // Agrega un texto u otro widget dentro del botón
      ),
    );
  }

  void refresh(){
    setState(() {

    });
  }
}*/

//VERSIÓN 2
class ClientProductsDetailPage extends StatefulWidget {
  final Product product;

  ClientProductsDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {
  final ClientProductDetailController _controllerProductsDetail = ClientProductDetailController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controllerProductsDetail.init(context, refresh, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _imageSlideshow(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _textName(),
                  SizedBox(height: 10),
                  _textDescription(),
                  SizedBox(height: 20),
                  _addRemoveItem(),
                  SizedBox(height: 10),
                  _deliveryUi(),
                  Spacer(),
                  _buttonShoppingBag(),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          indicatorColor: AppColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,
          autoPlayInterval: 5000, // Transición más lenta
          isLoop: true,
          children: [
            for (var image in [
              _controllerProductsDetail.product?.image1,
              _controllerProductsDetail.product?.image2,
              _controllerProductsDetail.product?.image3
            ])
              FadeInImage(
                image: image != null ? NetworkImage(image) : AssetImage('assets/img/burger.png') as ImageProvider,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/img/no-image-icon.png'),
                fadeInDuration: Duration(milliseconds: 600), // Transición más suave
              ),
          ],
        ),
        Positioned(
          left: 15,
          top: 40,
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.5),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textName() {
    return Text(
      _controllerProductsDetail.product?.name ?? '',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  Widget _textDescription() {
    return Text(
      _controllerProductsDetail.product?.description ?? '',
      style: TextStyle(fontSize: 14, color: Colors.blueGrey[700]),
    );
  }

  Widget _addRemoveItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.remove_circle_outline, size: 30, color: Colors.redAccent),
            ),
            Text(
              '1',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add_circle_outline, size: 30, color: Colors.green),
            ),
          ],
        ),
        Text(
          '${_formatPrice(_controllerProductsDetail.product?.price ?? 0)} Gs.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  Widget _deliveryUi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.delivery_dining, color: Colors.green, size: 30),
            SizedBox(width: 8),
            Text('Cobro por delivery', style: TextStyle(fontSize: 15, color: Colors.green[700])),
          ],
        ),
        Text('5.000 Gs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green[700])),
      ],
    );
  }

  Widget _buttonShoppingBag() {
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
          Icon(Icons.shopping_cart, color: Colors.white),
          SizedBox(width: 8),
          Text('Agregar al carrito', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

