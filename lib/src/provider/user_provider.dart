import 'dart:async';
import 'dart:convert';

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

}