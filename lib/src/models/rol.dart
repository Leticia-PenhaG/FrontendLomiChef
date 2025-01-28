import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  String id;
  String name;
  String? image;
  String route;

  Rol({
    required this.id,
    required this.name,
    required this.image,
    required this.route,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      image: json['image'],
      route: json['route'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'route': route,
    };
  }
}