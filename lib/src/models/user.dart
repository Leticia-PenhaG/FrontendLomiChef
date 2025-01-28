import 'dart:convert';

import 'package:lomi_chef_to_go/src/models/rol.dart';

class User {
  String? id; // Cambiar de int? a String?
  String email;
  String password;
  String? phone;
  String name;
  String? image;
  bool isAvailable;
  String? lastname;
  String? sessionToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Rol>? roles = [];

  User({
    this.id,
    required this.email,
    required this.password,
    this.phone,
    required this.name,
    this.image,
    this.isAvailable = false,
    this.lastname,
    this.sessionToken,
    this.createdAt,
    this.updatedAt,
    this.roles
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'].toString() : json['id'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      image: json['image'],
      isAvailable: json['is_available'] ?? false,
      lastname: json['lastname'],
      sessionToken: json['session_token'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      /*roles: json['roles'] == null ? [] : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))) ?? [],*/
      roles: json['roles'] is String
          ? List<Rol>.from(jsonDecode(json['roles']).map((model) => Rol.fromJson(model)))
          : List<Rol>.from(json['roles'].map((model) => Rol.fromJson(model))),
    );
  }

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

  static User fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return User.fromJson(jsonData);
  }

  String toJsonString() {
    return json.encode(toJson());
  }
}
