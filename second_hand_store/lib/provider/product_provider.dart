import 'package:flutter/cupertino.dart';
import 'package:second_hand_store/models/sanpham.dart';

import '../api_services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<SanPham> _sanphams = [];
  bool isLoading = false;
  int totalPage = 1;
  List<SanPham> get sanphams => _sanphams;

  Future<void> getAllProduct(int page) async {
    isLoading = true;
    if (page == 1) {
      _sanphams.clear();
    }
    final response = await ProductService.fetchData(page);
    List<SanPham> itemProduct = [];
    totalPage = await response["totalPage"];
    // log("Total Page $totalPage");
    response["arrImageProduct"].forEach((item) => {
          itemProduct.add(
            SanPham.fromJson(item),
          ),
        });

    _sanphams = _sanphams + itemProduct;
    isLoading = false;
    notifyListeners();
  }
  // Future<void> getAllProduct(int page) async {
  //   isLoading = true;
  //   final response = await ProductService.fetchData(page);
  //   _sanphams = _sanphams + response;
  //   isLoading = false;
  //   notifyListeners();
  // }
}
