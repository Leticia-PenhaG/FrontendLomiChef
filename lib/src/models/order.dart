import 'dart:convert';

import 'package:lomi_chef_to_go/src/models/product.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String id;
  String idClient;
  String idDelivery;
  String idAddress;
  String status;
  double lat;
  double lng;
  int timeStamp;
  List<Product> products = [];
  List<Order> toList = [];

  Order({
    required this.id,
    required this.idClient,
    required this.idDelivery,
    required this.idAddress,
    required this.status,
    required this.lat,
    required this.lng,
    required this.timeStamp,
    required this.products
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] is int ? json["id"].toString() : json['id'],
    idClient: json["id_client"],
    idDelivery: json["id_delivery"],
    idAddress: json["id_address"],
    status: json["status"],
    lat: json["lat"] is String? double.parse(json["lat"]) : json["lat"],
    lng: json["lng"] is String? double.parse(json["lng"]) : json["lng"],
    timeStamp: json["timeStamp"] is String ? int.parse(json["timeStamp"]) : json["timestamp"],
    //products: List <Product>.from(json["products"]).map((model) => Product.fromJson(model)) ??  [],
    products: json["products"] != null
        ? List<Product>.from(json["products"].map((model) => Product.fromJson(model)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_client": idClient,
    "id_delivery": idDelivery,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "timeStamp": timeStamp,
    "products": products,
  };
}