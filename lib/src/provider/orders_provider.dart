import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/api/environment.dart';
import 'package:lomi_chef_to_go/src/models/order.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../models/user.dart';

class OrdersProvider {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/orders';
  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<ResponseApi?> createOrder(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(order);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      if(res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        //new SharedPreferencesHelper().logout(context);
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> markOrderAsReadyToDeliver(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/markAsReadyToDeliver');

      String bodyParams = json.encode(order);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return null;
      }

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> updateOrderToOnTheWay(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateOrderToOnTheWay');

      String bodyParams = json.encode(order);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return null;
      }

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi?> updateToDeliveryCompleted(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateToDeliveryCompleted');

      String bodyParams = json.encode(order);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return null;
      }

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Order>>getByStatus(String status) async {
    try {
      Uri url = Uri.parse('http://$_url$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? '',
      };

      // Verificación del token antes de realizar la solicitud
      if (sessionUser.sessionToken == null || sessionUser.sessionToken!.isEmpty) {
        Fluttertoast.showToast(msg: 'Token de sesión inválido');
        return [];
      }

      final res = await http.get(url, headers: headers);

      print('URL solicitada: $url');
      print('Código de respuesta: ${res.statusCode}');
      print('Respuesta del servidor: ${res.body}');

      // Manejo de respuesta
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return [];
      } else if (res.statusCode == 200 || res.statusCode == 201) {
        try {
          final List<dynamic> data = json.decode(res.body);
          List<Order> orders = data.map((item) => Order.fromJson(item)).toList();
          print("Órdenes obtenidas en frontend: $orders");
          return orders;
        } catch (e) {
          print('Error al parsear JSON: $e');
          Fluttertoast.showToast(msg: 'Error al procesar las órdenes');
          return [];
        }
      } else {
        Fluttertoast.showToast(msg: 'Error al traer órdenes: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en getByStatus: $e');
      Fluttertoast.showToast(msg: 'Error en la conexión');
      return [];
    }
  }

  Future<List<Order>>getOrdersByDeliveryAndStatus(String idDelivery, String status) async {
    try {
      Uri url = Uri.parse('http://$_url$_api/getOrdersByDeliveryAndStatus/$idDelivery/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? '',
      };

      // Verificación del token antes de realizar la solicitud
      if (sessionUser.sessionToken == null || sessionUser.sessionToken!.isEmpty) {
        Fluttertoast.showToast(msg: 'Token de sesión inválido');
        return [];
      }

      final res = await http.get(url, headers: headers);

      print('URL solicitada: $url');
      print('Código de respuesta: ${res.statusCode}');
      print('Respuesta del servidor: ${res.body}');

      // Manejo de respuesta
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return [];
      } else if (res.statusCode == 200 || res.statusCode == 201) {
        try {
          final List<dynamic> data = json.decode(res.body);
          List<Order> orders = data.map((item) => Order.fromJson(item)).toList();
          print("Órdenes obtenidas en frontend: $orders");
          return orders;
        } catch (e) {
          print('Error al parsear JSON: $e');
          Fluttertoast.showToast(msg: 'Error al procesar las órdenes');
          return [];
        }
      } else {
        Fluttertoast.showToast(msg: 'Error al traer órdenes: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en getByStatus: $e');
      Fluttertoast.showToast(msg: 'Error en la conexión');
      return [];
    }
  }

  Future<List<Order>>getOrdersByClientAndStatus(String idClient, String status) async {
    try {
      Uri url = Uri.parse('http://$_url$_api/getOrdersByClientAndStatus/$idClient/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? '',
      };

      // Verificación del token antes de realizar la solicitud
      if (sessionUser.sessionToken == null || sessionUser.sessionToken!.isEmpty) {
        Fluttertoast.showToast(msg: 'Token de sesión inválido');
        return [];
      }

      final res = await http.get(url, headers: headers);

      print('URL solicitada: $url');
      print('Código de respuesta: ${res.statusCode}');
      print('Respuesta del servidor: ${res.body}');

      // Manejo de respuesta
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return [];
      } else if (res.statusCode == 200 || res.statusCode == 201) {
        try {
          final List<dynamic> data = json.decode(res.body);
          List<Order> orders = data.map((item) => Order.fromJson(item)).toList();
          print("Órdenes obtenidas en frontend: $orders");
          return orders;
        } catch (e) {
          print('Error al parsear JSON: $e');
          Fluttertoast.showToast(msg: 'Error al procesar las órdenes');
          return [];
        }
      } else {
        Fluttertoast.showToast(msg: 'Error al traer órdenes: ${res.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error en getByStatus: $e');
      Fluttertoast.showToast(msg: 'Error en la conexión');
      return [];
    }
  }

  Future<ResponseApi?> updateLatLng(Order order) async {
    try {
      Uri url = Uri.http(_url, '$_api/updateLatLng');

      String bodyParams = json.encode(order);

      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.put(url, headers: headers, body: bodyParams);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
        return null;
      }

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);

    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
