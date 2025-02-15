import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/api/environment.dart';
import '../models/response_api.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _url = Environment.API_DELIVERY;
  final String _api = '/api/users';

  late BuildContext context;

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero);
  }

  Future<Stream?> createWithImage (User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST',url);
      /*if(image != null) {

        request.files.add(
          http.MultipartFile(
            'image',  // Asegúrate de que el nombre aquí coincide con el que se espera en el servidor
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: image.path.split('/').last,
          ),
        );
      }*/

      if (image != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            http.ByteStream(image.openRead().cast()),
            await image.length(),
            filename: image.path.split('/').last,
          ),
        );
        print("Imagen añadida a la solicitud");
      } else {
        print("No se ha enviado ninguna imagen");
      }

      //request.fields['files'] = json.encode(user);
      request.fields['user'] = json.encode(user);

      final response = await request.send();//se envía la petición a node.js
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error: $e');
      return null;
    }

  }
    Future<ResponseApi?> create (User user) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(user);
      Map<String, String> headers = {
        'Content-type' : 'application/json'
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body); //almacena la respuesta que retorna node.js al momento de realizar la petición
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;

    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> login (String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({
        'email':email,
        'password':password
      });
      Map<String, String> headers = {
        'Content-type' : 'application/json'
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body); //almacena la respuesta que retorna node.js al momento de realizar la petición
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;

    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }

}