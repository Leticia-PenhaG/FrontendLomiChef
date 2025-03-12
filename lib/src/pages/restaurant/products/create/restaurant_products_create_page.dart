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

  final RestaurantProductsCreateController _controllerRestaurantProducts = RestaurantProductsCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controllerRestaurantProducts.init(context, refresh);
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
            _dropDownCategories(_controllerRestaurantProducts.categories)
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
      controller: _controllerRestaurantProducts.nameController,
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
      //controller: _controllerRestaurantProducts.priceController, //falta colocar en formato precio
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
      controller: _controllerRestaurantProducts.descriptionController,
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

  // Widget  _dropDownCategories(List<Category> categories) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 33),
  //     child: Material(
  //       elevation: 2.0,
  //       color: Colors.white,
  //       borderRadius: BorderRadius.all(Radius.circular(5)),
  //       child: Container(
  //         padding: EdgeInsets.all(10),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Icon(
  //                   Icons.search,
  //                   color: AppColors.primaryColor,
  //                 ),
  //                 SizedBox(width: 15),
  //                 Text(
  //                   'Categorías',
  //                   style: TextStyle(color: Colors.grey, fontSize: 16),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 20),
  //               child: DropdownButton(
  //                 underline: Container(
  //                   alignment: Alignment.centerRight,
  //                   child: Icon(
  //                     Icons.arrow_drop_down_circle,
  //                     color: AppColors.primaryColor,
  //                   ),
  //                 ),
  //                 elevation: 3,
  //                 isExpanded: true,
  //                 hint: Text(
  //                     'Seleccioná la categoría',
  //                   style: TextStyle(
  //                     color: Colors.grey,
  //                     fontSize: 16
  //                   ),
  //                 ),
  //                 items: _dropdownItems(categories),
  //                 value: _controllerRestaurantProducts.idCategory,
  //                 onChanged: (option) {
  //                   setState(() {
  //                     print('Categoría seleccionada $option');
  //                     _controllerRestaurantProducts.idCategory = option!; //se establece el valor seleccionado
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _dropDownCategories(List<Category> categories) {
    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No hay categorías disponibles',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
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
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  items: _dropdownItems(categories),
                  value: categories.any((c) => c.id == _controllerRestaurantProducts.idCategory)
                      ? _controllerRestaurantProducts.idCategory
                      : null,
                  onChanged: (option) {
                    setState(() {
                      print('Categoría seleccionada $option');
                      _controllerRestaurantProducts.idCategory = option!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropdownItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category){
      list.add(DropdownMenuItem(
          child: Text(category.name!),
          value: category.id,
      ));
    });
    return list;
  }

  Widget _buttonCreate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _controllerRestaurantProducts.createProduct,
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


/*
class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({super.key});

  @override
  State<RestaurantProductsCreatePage> createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {
  File? _image1, _image2, _image3;
  String? _selectedCategory;
  final List<String> _categories = ['Bebidas', 'Hamburguesas', 'Pizzas'];

  Future<void> _pickImage(int imageNumber) async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) _image1 = File(pickedFile.path);
        if (imageNumber == 2) _image2 = File(pickedFile.path);
        if (imageNumber == 3) _image3 = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Agregar Producto', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nombre del producto', Icons.local_pizza_rounded),
            const SizedBox(height: 15),
            _buildTextField('Descripción', Icons.description, maxLines: 3),
            const SizedBox(height: 15),
            _buildTextField('Precio', Icons.attach_money, keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            _buildImagePickerRow(),
            const SizedBox(height: 20),
            _buildCategoryDropdown(),
          ],
        ),
      ),
      bottomNavigationBar: _buildCreateButton(),
    );
  }

  Widget _buildTextField(String label, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon, color: Colors.redAccent),
      ),
    );
  }

  Widget _buildImagePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _imageCard(_image1, 1),
        _imageCard(_image2, 2),
        _imageCard(_image3, 3),
      ],
    );
  }

  Widget _imageCard(File? imageFile, int numberFile) {
    return InkWell(
      onTap: () => _pickImage(numberFile),
      child: Card(
        elevation: 3.0,
        child: Container(
          height: 100,
          width: MediaQuery.of(context).size.width * 0.26,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: imageFile != null
                ? DecorationImage(image: FileImage(imageFile), fit: BoxFit.cover)
                : const DecorationImage(image: AssetImage('assets/img/cart.png')),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCategory,
          hint: const Text('Selecciona una categoría', style: TextStyle(color: Colors.grey)),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.redAccent),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category, style: const TextStyle(fontSize: 16)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Crear Producto',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
*/
