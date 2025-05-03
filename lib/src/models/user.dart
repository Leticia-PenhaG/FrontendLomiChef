import 'dart:convert';
import 'package:lomi_chef_to_go/src/models/rol.dart';
import 'package:lomi_chef_to_go/src/models/user.dart';

class User {
  String? id;
  String? email;
  String? password;
  String? phone;
  String name;
  String? image;
  bool isAvailable;
  String lastname;
  String? sessionToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Rol>? roles;
  List<User> toList = [];

  // Constructor principal
  User({
    this.id,
    this.email,
    this.password,
    this.phone,
    required this.name,
    this.image,
    this.isAvailable = false,
    required this.lastname,
    this.sessionToken,
    this.createdAt,
    this.updatedAt,
    this.roles,
  });

  // Convertir un JSON a User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'].toString() : json['id'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      isAvailable: json['is_available'] ?? false,
      lastname: json['lastname'] ?? '',
      sessionToken: json['session_token'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      // roles: json['roles'] is String
      //     ? List<Rol>.from(jsonDecode(json['roles']).map((model) => Rol.fromJson(model)))
      //     : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))), //FORMA ORIGINAL ANTES DE CAMBIAR POR EL CRASH EN SELECCIONAR DELIVERY
      roles: json['roles'] != null
          ? (json['roles'] is String
          ? List<Rol>.from(jsonDecode(json['roles']).map((model) => Rol.fromJson(model)))
          : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))))
          : null,
    );
  }

  // Convertir una lista de JSONs a una lista de User
  static List<User> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => User.fromJson(item)).toList();
  }

  // Convertir User a Map (para enviar al servidor o guardar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'phone': phone,
      'name': name,
      'image': image,
      'is_available': isAvailable,
      'lastname': lastname,
      'session_token': sessionToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'roles': roles?.map((rol) => rol.toJson()).toList(),
    };
  }

  // Métodos extra por conveniencia
  static User fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return User.fromJson(jsonData);
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
