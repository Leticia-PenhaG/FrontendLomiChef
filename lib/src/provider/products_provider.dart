import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/api/environment.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user.dart';

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
          'images', // 🔹 Asegúrate de que coincida con el nombre en Multer
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

}
