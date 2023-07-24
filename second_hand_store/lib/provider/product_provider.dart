import 'package:flutter/cupertino.dart';
import 'package:second_hand_store/models/sanpham.dart';

import '../api_services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  List<SanPham> _sanphams = [];
  List<SanPham> _sanphamWithId = [];
  List<SanPham> _sanphamSearch = [];
  List<SanPham> get sanphams => _sanphams;
  List<SanPham> get sanphamWithId => _sanphamWithId;
  List<SanPham> get sanphamSearch => _sanphamSearch;
  bool isLoading = false;
  int totalPage = 1;

  Future<void> getAllProduct({int? page, int? limit}) async {
    isLoading = true;
    if (page == 1) {
      _sanphams.clear();
    }
    final response = await ProductService.fetchData(page: page, limit: limit);
    print(response);
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

  Future<void> getAllProductWithID({String? id}) async {
    isLoading = true;

    final response = await ProductService.fetchDataWithID(id: id);
    _sanphamWithId.clear();
    print(response);
    List<SanPham> itemProduct = [];

    if (response.isNotEmpty) {
      response["arrImageProduct"].forEach((item) => {
            itemProduct.add(
              SanPham.fromJson(item),
            ),
          });

      _sanphamWithId = itemProduct;
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearProductSearch() {
    _sanphamSearch.clear();
    notifyListeners();
  }

  Future<void> searchProduct(
      {String? key, double? minPrice, double? maxPrice}) async {
    isLoading = true;

    final response = await ProductService.searchData(
        key: key, minPrice: minPrice, maxPrice: maxPrice);

    // print(response);
    List<SanPham> itemProduct = [];

    if (response.isNotEmpty) {
      response["arrImageProduct"].forEach((item) => {
            itemProduct.add(
              SanPham.fromJson(item),
            ),
          });
      _sanphamSearch = itemProduct;
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }
}
