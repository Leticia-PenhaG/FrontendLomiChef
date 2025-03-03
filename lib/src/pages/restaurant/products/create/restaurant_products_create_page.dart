import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lomi_chef_to_go/src/models/category.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:lomi_chef_to_go/src/utils/app_colors.dart';

class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({super.key});

  @override
  State<RestaurantProductsCreatePage> createState() =>
      _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState
    extends State<RestaurantProductsCreatePage> {
  bool isBtnCreateEnabled = false;

  final RestaurantProductsCreateController _controllerCategories =
      RestaurantProductsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controllerCategories.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title:
            const Text('Nuevo Producto', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleSection('Información del producto'),
            const SizedBox(height: 15),
            _textFieldName(),
            const SizedBox(height: 15),
            _textFieldDescription(),
            const SizedBox(height: 15),
            _textFieldPrice(),
            Container(
              height: 100,
              //margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _cardImage(null, 1),
                  _cardImage(null, 2),
                  _cardImage(null, 3),
                ],
              ),
            ),
            _dropDownCategories([])
          ],
        ),
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _titleSection(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      ),
    );
  }

  Widget _textFieldName() {
    return TextField(
      controller: _controllerCategories.nameController,
      maxLines: 1,
      maxLength: 180,
      decoration: InputDecoration(
        labelText: 'Nombre del producto',
        labelStyle: const TextStyle(color: AppColors.textColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        prefixIcon: const Icon(Icons.local_pizza_rounded,
            color: AppColors.secondaryColor),
      ),
    );
  }

  Widget _textFieldPrice() {
    return TextField(
      //controller: _controllerCategories.priceController, //falta colocar en formato precio
      maxLines: 1,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Precio',
        labelStyle: const TextStyle(color: AppColors.textColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        prefixIcon: const Icon(Icons.monetization_on_rounded,
            color: AppColors.secondaryColor),
      ),
    );
  }

  Widget _textFieldDescription() {
    return TextField(
      controller: _controllerCategories.descriptionController,
      maxLines: 3,
      maxLength: 255,
      decoration: InputDecoration(
        labelText: 'Descripción del producto',
        labelStyle: const TextStyle(color: AppColors.textColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.secondaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppColors.secondaryColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        prefixIcon:
            const Icon(Icons.description, color: AppColors.secondaryColor),
      ),
    );
  }

  Widget _cardImage(File? imageFile, int numberFile) {
    return imageFile != null
        ? Card(
            elevation: 3.0,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.26,
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
          )
        : Card(
            elevation: 3.0,
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width * 0.26,
              child: Image(image: AssetImage('assets/img/cart.png')),
            ),
          );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Categorías',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  /*Material(
                      elevation: 0, //sin sombra
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(Icons.search,
                      color: AppColors.primaryColor,
                      ),
                    )*/
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                  underline: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_drop_down_circle,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  elevation: 3,
                  isExpanded: true,
                  hint: Text(
                      'Seleccioná la categoría',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16
                    ),
                  ),
                  items: [

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonCreate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _controllerCategories.createProduct,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
          ),
          child: const Text(
            'Crear Producto',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
