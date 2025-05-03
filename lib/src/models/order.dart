import 'dart:convert';
import 'package:lomi_chef_to_go/src/models/product.dart';
import 'package:lomi_chef_to_go/src/models/user.dart';

class Order {
  String id;
  String idClient;
  String? idDelivery;
  String idAddress;
  String status;
  double lat;
  double lng;
  int timeStamp;
  List<Product> products;

  // Nuevos campos
  Map<String, dynamic>? client;
  Map<String, dynamic>? address;
  //User? delivery;
  Map<String, dynamic>? delivery;

  Order({
    required this.id,
    required this.idClient,
    this.idDelivery,
    required this.idAddress,
    required this.status,
    required this.lat,
    required this.lng,
    required this.timeStamp,
    required this.products,
    this.client,
    this.address,
    this.delivery,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"] is int ? json["id"].toString() : json["id"] ?? '',
      idClient: json["id_client"] ?? '',
      idDelivery: json["id_delivery"],
      idAddress: json["id_address"] ?? '',
      status: json["status"] ?? '',
      lat: json["lat"] is String ? double.parse(json["lat"]) : (json["lat"] ?? 0.0),
      lng: json["lng"] is String ? double.parse(json["lng"]) : (json["lng"] ?? 0.0),
      //timeStamp: json["timeStamp"] is String ? int.parse(json["timeStamp"]) : (json["timeStamp"] ?? 0),
      timeStamp: json["timestamp"] is String
          ? int.parse(json["timestamp"])
          : (json["timestamp"] ?? 0),
      products: json["products"] != null
          ? (json["products"] is String
          ? List<Product>.from(
          jsonDecode(json["products"]).map((model) => Product.fromJson(model)))
          : List<Product>.from(
          json["products"].map((model) => Product.fromJson(model))))
          : [],
      client: json["client"] != null ? jsonDecode(json["client"]) : null,
      delivery: json["delivery"] != null ? jsonDecode(json["delivery"]) : null,
      address: json["address"] != null ? jsonDecode(json["address"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_client": idClient,
    "id_delivery": idDelivery,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "timeStamp": timeStamp,
    "products": products.map((p) => p.toJson()).toList(),
    "client": client != null ? jsonEncode(client) : null,
    "address": address != null ? jsonEncode(address) : null,
    "delivery": delivery != null ? jsonEncode(delivery) : null,
  };
}



