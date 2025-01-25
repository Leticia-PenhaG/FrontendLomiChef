import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/*
* Permite almacenar y recuperar información, como tokens de sesión o datos de usuario.
* Usa json.encode y json.decode para manejar datos complejos como mapas.*/

class SharedPreferencesHelper {
  // Guarda un valor codificado en JSON en las preferencias compartidas usando una clave específica.
  Future<void> saveSessionToken(String key, value) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString(key, json.encode(value));
  }

  // Lee un valor almacenado codificado en JSON y lo decodifica a su formato original.
  Future<dynamic> readSessionToken(String key) async {
    final preferences = await SharedPreferences.getInstance();
    final storedValue = preferences.getString(key);
    if (storedValue == null) return null;
    return json.decode(storedValue); // Decodifica el valor JSON.
  }

  // Comprueba si una clave específica existe en las preferencias compartidas.
  Future<bool> containsSessionToken(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.containsKey(key);
  }

  // Elimina un valor almacenado asociado con una clave específica.
  Future<bool> clearSession(String key) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.remove(key);
  }
}
