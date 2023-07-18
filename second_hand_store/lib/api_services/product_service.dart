import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:second_hand_store/models/sanpham.dart';

class ProductService {
  static Future<Map<String, dynamic>> fetchData({int? page, int? limit}) async {
    final response = await http.get(
      Uri.parse(
        "http://${dotenv.env["IPV4"]}:${dotenv.env["PORT"]}/api/sanpham?page=$page&limit=$limit",
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(json.decode(response.body));
      return jsonResponse;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  static Future<bool> postData(SanPham sanPham) async {
    final response = await http.post(
        Uri.parse(
            'http://${dotenv.env["IPV4"]}:${dotenv.env["PORT"]}/api/sanpham'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(sanPham));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      log(jsonResponse.toString());
      return true;
    } else {
      return false;
    }
  }
}
