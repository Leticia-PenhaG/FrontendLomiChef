import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  String? id;
  String idUser;
  String address;
  String neighborhood;
  double lat;
  double lng;

  Address({
    this.id,
    required this.idUser,
    required this.address,
    required this.neighborhood,
    required this.lat,
    required this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"] is int ? json['id'].toString() : json['id'],
    idUser: json["id_user"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    lat: json["lat"] is String ? double.parse(json["lat"]) : json["lat"].toDouble(),
    lng: json["lng"] is String ? double.parse(json["lng"]) : json["lng"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_user": idUser,
    "address": address,
    "neighborhood": neighborhood,
    "lat": lat,
    "lng": lng,
  };
}
