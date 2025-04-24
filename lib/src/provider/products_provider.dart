import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/api/environment.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user.dart';
import '../utils/shared_preferences_helper.dart';

class ProductsProvider {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/products';
  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<http.StreamedResponse?> createProduct(Product product, List<File> images) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = sessionUser.sessionToken!; //se le pasa el token para que realice la llamada

      // Convertir el objeto product a JSON y enviarlo como un campo del formulario
      request.fields['product'] = jsonEncode(product.toJson());

      for (int i = 0; i < images.length; i++) {
        var stream = http.ByteStream(images[i].openRead());
        var length = await images[i].length();
        var multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: basename(images[i].path),
        );
        request.files.add(multipartFile);
      }

      return await request.send();
    } catch (e) {
      print('Error al enviar imagen: $e');
      return null;
    }
  }

  Future<List<Product>> getProductByCategory(String idCategory) async {
    try {
      Uri url = Uri.parse('http://$_url$_api/findByCategory/$idCategory');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
      }

      // final List<dynamic> data = json.decode(res.body); // Asegurar que es una lista
      // List<Category> categories = data.map((item) => Category.fromJson(item)).toList();

      final data = json.decode(res.body); // Asegurar que es una lista
      Product product = Product.fromJsonList(data);

      //print("Categorías obtenidas en frontend: $categories");

      return product.toList;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }


}
