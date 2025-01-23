import 'dart:convert';

class User {
  int? id;
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
  });

  // Factory constructor para crear un objeto User desde un JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      name: json['name'],
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
    );
  }

  // Método para convertir un objeto User a un JSON
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
    };
  }

  // Método para convertir un JSON string a un objeto User
  static User fromJsonString(String jsonString) {
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return User.fromJson(jsonData);
  }

  // Método para convertir un objeto User a un JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}