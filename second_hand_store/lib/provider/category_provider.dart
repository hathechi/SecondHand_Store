import 'package:flutter/cupertino.dart';
import 'package:second_hand_store/api_services/category_service.dart';
import 'package:second_hand_store/models/danhmuc.dart';

class CategoryProvider extends ChangeNotifier {
  List<DanhMuc> _danhmucs = [];
  bool isLoading = false;

  List<DanhMuc> get danhmucs => _danhmucs;

  Future<void> getAll() async {
    isLoading = true;

    final danhmuc = await CategoryService.fetchData();
    _danhmucs = danhmuc;
    isLoading = false;
    notifyListeners();
  }
}
