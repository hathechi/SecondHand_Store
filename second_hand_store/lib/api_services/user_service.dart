import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_preferences.dart';

class UserService {
  static Future<void> postData(User user) async {
    var response = await http.post(
      Uri.parse(
          'http://${dotenv.env["IPV4"]}:${dotenv.env["PORT"]}/api/nguoidung'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "ten": user.displayName,
          "email": user.email,
          "url_avatar": user.photoURL
        },
      ),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //Lưu vào share_preferences
      saveToLocalStorage(jsonResponse["data"], "user");
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
