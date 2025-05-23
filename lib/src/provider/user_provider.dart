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
  bool logoutAlreadyCalled = false;

  late BuildContext context;
  User? sessionUser;

  Future<void> init(BuildContext context, {User? sessionUser}) async {
    this.context = context;
    this.sessionUser = sessionUser;
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

  Future<ResponseApi?> updateNotificationToken(String idUser, String token) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      String bodyParams = json.encode({
        'id':idUser,
        'notification_token':token
      });

      if (sessionUser?.sessionToken == null) {
        Fluttertoast.showToast(msg: 'Token de sesión no disponible');
        return null;
      }

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser!.sessionToken!,
      };

      final response = await http.put(url, headers: headers, body: bodyParams);

      if(response.statusCode == 401) {        //Respuesta no autorizada
        Fluttertoast.showToast(msg: 'La sesión expiró');
        new SharedPreferencesHelper().logout(context, sessionUser!.id!);
      }

      // if (response.statusCode == 401) {
      //   if (!logoutAlreadyCalled) {
      //     logoutAlreadyCalled = true;
      //     Fluttertoast.showToast(msg: 'Sesión expirada');
      //     new SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');
      //   }
      // }

      final data = json.decode(response.body);

      ResponseApi responseApi = ResponseApi.fromJson(data);

      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Future<http.Response> updateNotificationToken(String? userId, String? token) async {
  //   final url = Uri.parse('$_api/updateNotificationToken');
  //
  //   final response = await http.put(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer ${sessionUser?.sessionToken ?? ''}', // esto es clave
  //     },
  //     body: jsonEncode({
  //       'id': userId,
  //       'updateNotificationToken': token
  //     }),
  //   );
  //
  //   return response;
  // }

  /*Future<ResponseApi?> updateNotificationToken(String? idUser, String? token) async {
    try {
      // Construcción de la URL y parámetros
      // final Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      // final String bodyParams = json.encode({
      Uri url = Uri.http(_url, '$_api/updateNotificationToken');
      String bodyParams = json.encode({
        'id': idUser,
        'notification_token': token
      });

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': sessionUser?.sessionToken ?? ''
      };

      // Logs para debug
      print('🔁 Enviando token de notificación: $token');
      print('🔗 URL: $url');
      print('📦 Body: $bodyParams');
      print('🔐 Headers: $headers');

      // Solicitud PUT
      final http.Response response = await http.put(url, headers: headers, body: bodyParams);

      print('📥 Respuesta: ${response.statusCode} ${response.body}');

      // Manejo de sesión expirada
      if (response.statusCode == 401 && !logoutAlreadyCalled) {
        logoutAlreadyCalled = true;
        Fluttertoast.showToast(msg: 'Sesión expirada');
        //await SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');
        SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');

        return null;
      }

      // Decodificación y retorno
      final Map<String, dynamic> data = json.decode(response.body);
      return ResponseApi.fromJson(data);
    } catch (e, stacktrace) {
      print('❌ Error al actualizar el token de notificación: $e');
      print('📌 Stacktrace: $stacktrace');
      return null;
    }
  }*/


  Future<Stream<String>?> updateProfile(User user, File? image) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      var request = http.MultipartRequest('PUT', url);

      // Usar sessionUser de manera segura
      if (sessionUser != null) {
        request.headers['Authorization'] = sessionUser!.sessionToken!;
      }
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
        new SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');
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
        'Authorization' : sessionUser?.sessionToken ?? ''  // Si sessionUser es null, se pasa una cadena vacía
      };
      final res = await http.get(url, headers: headers);

      if(res.statusCode == 401) { //Respuesta no autorizada
        Fluttertoast.showToast(msg: 'La sesión expiró');
        new SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');
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

  Future<List<User>> loadCouriers() async {
    try {
      Uri url = Uri.http(_url, '$_api/loadCouriers');

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser?.sessionToken ?? ''
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'La sesión expiró');
        SharedPreferencesHelper().logout(context, sessionUser?.id ?? '');
        return [];
      }

      final data = json.decode(res.body);

      // Si responde con un objeto con clave 'data', usá esto:
      List<User> userList = User.fromJsonList(data['data']);
      return userList;

    } catch (e) {
      print('Error: $e');
      return [];
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

  Future<ResponseApi?> logout(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/logout');

      String bodyParams = json.encode({'id': idUser});

      Map<String, String> headers = {
        'Content-type' : 'application/json'
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body); //almacena la respuesta que retorna node.js al momento de realizar la petición
      print("Respuesta Logout: $data"); // DEBUG

      ResponseApi responseApi = ResponseApi.fromJson(data);

      if (!responseApi.success) {
        Fluttertoast.showToast(msg: "Error al cerrar sesión: ${responseApi.message}");
        return null;
      }

      return responseApi;

    }
    catch(e) {
      print('Error: $e');
      return null;
    }
  }
}