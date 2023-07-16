import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:second_hand_store/models/danhmuc.dart';

class CategoryService {
  static Future<List<DanhMuc>> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'http://${dotenv.env["IPV4"]}:${dotenv.env["PORT"]}/api/danhmuc'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<DanhMuc> danhmucs = [];
      jsonResponse.forEach((item) => {
            danhmucs.add(
              DanhMuc.fromJson(item),
            ),
          });
      return danhmucs;
      //làm theo cách trên hoặc dưới đều được
      // return jsonResponse.map((job) => Product.fromJson(job)).toList();
    } else {
      throw Exception('Failed to fetch data');
    }
  }
  // static Future<dynamic> fetchData(int page) async {
  //   int? totalPage;
  //   final response = await http.get(
  //     Uri.parse('http://192.168.111.23:3000/api/sanpham/page/$page'),
  //     headers: {"Content-Type": "application/json"},
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //     List<SanPham> itemProduct = [];
  //     totalPage = jsonResponse["totalPage"];
  //     log(totalPage.toString());
  //     jsonResponse["arrImageProduct"].forEach((item) => {
  //           itemProduct.add(
  //             SanPham.fromJson(item),
  //           ),
  //         });
  //     return itemProduct;
  //     //làm theo cách trên hoặc dưới đều được
  //     // return jsonResponse.map((job) => Product.fromJson(job)).toList();
  //   } else {
  //     throw Exception('Failed to fetch data');
  //   }
  // }
}
