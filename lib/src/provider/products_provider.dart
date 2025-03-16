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

  Future<Stream<String>?> createProduct(Product product, List<File> images) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = sessionUser.sessionToken!; //se le pasa el token para que realice la llamada

      for(int i = 0; i < images.length; i++) {
        print('Subiendo imagen: ${images[i].path}');
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)
        ));
      }

      /*for (int i = 0; i < images.length; i++) {
        print('Subiendo imagen: ${images[i].path}');
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path),
          ),
        );
      }*/

      /*for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
          'image${i + 1}', // Cambiar 'image' por 'image1', 'image2', 'image3'
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path),
        ));
      }*/

      //request.fields['product'] = json.encode(product); // Convertir user a JSON
      request.fields['product'] = json.encode(product.toJson());

      var response = await request.send();
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error al enviar imagen: $e');
      return null;
    }
  }
}
