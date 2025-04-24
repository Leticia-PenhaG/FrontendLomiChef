import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/api/environment.dart';
import 'package:lomi_chef_to_go/src/models/Address.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../models/user.dart';

class AddressProvider {
  String _url = Environment.API_DELIVERY;
  String _api = '/api/address';
  late BuildContext context;
  late User sessionUser;

  Future<void> init(BuildContext context, User sessionUser) async {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Address>> getByUser(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByUser/$idUser');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken ?? ''
      };

      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión expirada');
        new SharedPreferencesHelper().logout(context, sessionUser.id!);
      }

      final List<dynamic> data = json.decode(res.body);
      return data.map((item) => Address.fromJson(item)).toList();

    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi?> createAddress(Address address) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(address);
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
}
