import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

void saveToLocalStorage(dynamic object, String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String jsonString = jsonEncode(object);
  prefs.setString(key, jsonString);
  log('save ok');
}

Future<dynamic> getFromLocalStorage(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonString = prefs.getString(key);
  if (jsonString != null) {
    return jsonDecode(jsonString);
  } else {
    return null;
  }
}

void deleteToLocalStorage(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}
