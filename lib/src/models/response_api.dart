import 'dart:convert';

// Método para convertir JSON en un objeto ResponseApi
ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

// Método para convertir un objeto ResponseApi a JSON
String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  String message;
  bool success;
  dynamic data; // Puede ser cualquier cosa: un objeto, una lista o null
  String? error; // Puede ser nulo

  ResponseApi({
    required this.message,
    required this.success,
    this.data,
    this.error,
  });

  // Constructor para deserializar desde JSON
  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    success: json["success"],
    message: json["message"],
    error: json["error"], // Podría ser null
    data: json["data"], // Asignar tal cual ya que puede ser cualquier tipo
  );

  // Método para serializar a JSON
  Map<String, dynamic> toJson() => {
    "message": message,
    "success": success,
    "error": error,
    "data": data, // Puede ser cualquier tipo  /*REVISAR*/
  };
}