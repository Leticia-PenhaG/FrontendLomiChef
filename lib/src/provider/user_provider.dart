import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/api/environment.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../models/response_api.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _url = Environment.API_DELIVERY;
  final String _api = '/api/users';

  late BuildContext context;
  late String token;

  Future<void> init(BuildContext context, {String? token}) async {
    this.context = context;
    this.token = token ?? '';
    await Future.delayed(Duration.zero);
  }

  Future<Stream<String>?> createWithImage(User user, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      var request = http.MultipartRequest('POST', url);

      request.fields['user'] = json.encode(user.toJson()); // Convertir user a JSON

      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);

      var response = await request.send();
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error al enviar imagen: $e');
      return null;
    }
  }

  Future<Stream<String>?> updateProfile(User user, File? image) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      var request = http.MultipartRequest('PUT', url);

      request.headers['Authorization'] = token;       //token de sesión

      request.fields['user'] = json.encode(user.toJson());

      if (image != null) {
        // Solo se agrega la imagen si el usuario seleccionó una nueva
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();

        var multipartFile = http.MultipartFile(
          'image',
          stream,
          length,
          filename: image.path.split('/').last,
        );

        request.files.add(multipartFile);
      }

      var response = await request.send();

      if(response.statusCode == 401) {        //Respuesta no autorizada
        Fluttertoast.showToast(msg: 'La sesión expiró');
        new SharedPreferencesHelper().logout(context);
      }
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error al enviar imagen: $e');
      return null;
    }
  }

  //obtener el usuario por ID
  Future<User?> getUserById(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/getById/$id');

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization' : token
      };
      final res = await http.get(url, headers: headers);

      if(res.statusCode == 401) { //Respuesta no autorizada
        Fluttertoast.showToast(msg: 'La sesión expiró');
        new SharedPreferencesHelper().logout(context);
      }

      final data = json.decode(res.body);

      if (data['success'] == true) {
        User user = User.fromJson(data['data']); // Se extrae el objeto "data"
        return user;
      } else {
        print("Error al obtener usuario: ${data['message']}");
        return null;
      }
    } catch (e) {
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