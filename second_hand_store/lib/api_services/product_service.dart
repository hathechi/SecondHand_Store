import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:second_hand_store/models/sanpham.dart';

class ProductService {
  static Future<Map<String, dynamic>> fetchData({int? page, int? limit}) async {
    final response = await http.get(
      Uri.parse(
        "${dotenv.env["URL_SERVER"]}/api/sanpham?page=$page&limit=$limit",
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

  static Future fetchDataWithID({String? id}) async {
    final response = await http.get(
      Uri.parse(
        "${dotenv.env["URL_SERVER"]}/api/sanpham/user?id=$id",
      ),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      print(json.decode(response.body));
      return jsonResponse;
    } else {
      return {};
      // throw Exception('Failed to fetch data');
    }
  }

  static Future<bool> postData(SanPham sanPham) async {
    final response = await http.post(
        Uri.parse('${dotenv.env["URL_SERVER"]}/api/sanpham'),
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

  static Future<bool> updateData(SanPham sanPham) async {
    final response = await http.put(
        Uri.parse('${dotenv.env["URL_SERVER"]}/api/sanpham'),
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

  static Future<bool> deleteData(int idSanpham) async {
    final response = await http.delete(
        Uri.parse('${dotenv.env["URL_SERVER"]}/api/sanpham'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"id_sanpham": idSanpham}));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      log(jsonResponse.toString());
      return true;
    } else {
      return false;
    }
  }

  static Future searchData(
      {String? key, double? minPrice, double? maxPrice}) async {
    final response = await http.get(
      Uri.parse(
          '${dotenv.env["URL_SERVER"]}/api/search/sanpham?keyword=$key&minPrice=$minPrice&maxPrice=$maxPrice'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      log(jsonResponse.toString());

      return jsonResponse;
    } else {
      return {};
    }
  }
}
