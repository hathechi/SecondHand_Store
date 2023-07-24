// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/category_provider.dart';
import 'package:second_hand_store/provider/product_provider.dart';
import 'package:second_hand_store/utils/cache_image.dart';

import '../../utils/push_screen.dart';
import '../detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controllerSearch = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final providerCategory =
        Provider.of<CategoryProvider>(context, listen: false);
    providerCategory.getAll();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 80,
              ),
              height: MediaQuery.sizeOf(context).height * 0.15,
              color: const Color.fromARGB(255, 183, 230, 134),
              child: Form(
                key: formKey,
                child: inputSearch(controllerSearch: _controllerSearch),
              ),
            ),
            Expanded(
              child: Consumer<ProductProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.sanphamSearch.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 260,
                            ),
                            itemCount: value.sanphamSearch.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.only(right: 6, left: 6),
                                child: InkWell(
                                  onTap: () {
                                    pushScreen(
                                      context,
                                      DetailScreen(
                                          sanphams: value.sanphamSearch[index],
                                          saleOrEdit: true),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Builder(builder: (context) {
                                            return SizedBox(
                                              height: 200,
                                              // width: 200,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  child: cacheNetWorkImage(
                                                    '${dotenv.env["URL_IMAGE"]}${value.sanphamSearch[index].imageArr![0]}',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  )),
                                            );
                                          }),
                                          Positioned(
                                            bottom: 0,
                                            left: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                '${value.sanphamSearch[index].danhmuc}',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 4, left: 2),
                                        child: Text(
                                          value
                                              .sanphamSearch[index].tenSanpham!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 2, left: 2),
                                        child: Text(
                                          '${value.sanphamSearch[index].gia}k vnđ',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Đề xuất ❤ ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                // height: 300, // Độ cao của ListView
                                child: Consumer<CategoryProvider>(
                                  builder: (context, value, child) {
                                    return Wrap(
                                      direction: Axis
                                          .horizontal, // Thiết lập chiều ngang
                                      spacing:
                                          12, // Khoảng cách giữa các phần tử
                                      runSpacing:
                                          12, // Khoảng cách giữa các dòng (khi xuống hàng)
                                      children: List.generate(
                                        value.danhmucs.length,
                                        (index) {
                                          return InkWell(
                                            onTap: () {
                                              _controllerSearch.text = value
                                                  .danhmucs[index].tenDanhmuc!;
                                              provider.searchProduct(
                                                  key: value.danhmucs[index]
                                                      .tenDanhmuc!);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                value.danhmucs[index]
                                                    .tenDanhmuc!,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showBottomSheet(BuildContext context, String key) {
  double max = 50000.0;
  double min = 1.0;
  double? upper;
  double? lower;
  final provider = Provider.of<ProductProvider>(context, listen: false);

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
        color: Colors.transparent,
        width: double.infinity,
        // height: 25,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giá: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FlutterSlider(
                tooltip: FlutterSliderTooltip(
                    leftPrefix: const Icon(
                      Icons.attach_money,
                      size: 26,
                      color: Colors.white,
                    ),
                    rightSuffix: const Icon(
                      Icons.attach_money,
                      size: 26,
                      color: Colors.white,
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    boxStyle: FlutterSliderTooltipBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.redAccent.withOpacity(0.7)))),
                values: [min, max],
                rangeSlider: true,
                max: max,
                min: min,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  lower = lowerValue;
                  upper = upperValue;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 80),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  onPressed: () {
                    //tìm kiếm theo khoảng giá với keyword
                    provider.searchProduct(
                        key: key, minPrice: lower, maxPrice: upper);
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tìm kiếm',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        CupertinoIcons.search,
                        color: Colors.white,
                        size: 19,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class inputSearch extends StatefulWidget {
  const inputSearch({
    super.key,
    required TextEditingController controllerSearch,
  }) : _controllerSearch = controllerSearch;

  final TextEditingController _controllerSearch;

  @override
  State<inputSearch> createState() => _inputSearchState();
}

class _inputSearchState extends State<inputSearch> {
  bool isIconClose = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi nội dung của TextField
    widget._controllerSearch.addListener(_updateIconVisibility);
  }

  @override
  void dispose() {
    widget._controllerSearch.removeListener(_updateIconVisibility);
    widget._controllerSearch.dispose();
    super.dispose();
  }

  void _updateIconVisibility() {
    // Kiểm tra nếu có dữ liệu trong TextField thì hiển thị icon close
    // Ngược lại, ẩn icon close
    setState(() {
      isIconClose = widget._controllerSearch.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: TextFormField(
            onFieldSubmitted: (value) {
              if (value.isNotEmpty) {
                provider.searchProduct(key: value);
                log(value);
              }
            },
            onChanged: (value) {
              //Nếu có dữ liệu input thì gọi api
              if (value.isNotEmpty) {
                provider.searchProduct(key: value);
                log(value);
              } else {
                //ngược lại nếu không có thì xóa data product cũ
                provider.clearProductSearch();
              }
            },
            controller: widget._controllerSearch,
            decoration: InputDecoration(
                hintText: 'Tìm tên, danh mục sản phẩm ',
                alignLabelWithHint: true,
                filled: true, // Hiển thị màu nền
                fillColor: const Color.fromARGB(255, 255, 255, 255),
                hintStyle: const TextStyle(fontSize: 15),
                contentPadding: const EdgeInsets.only(left: 16),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(0.5),
                ),
                suffixIcon: isIconClose
                    ? IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        onPressed: () {
                          widget._controllerSearch.clear();
                          _updateIconVisibility();
                          //xóa data product cũ khi xóa dữ liệu input
                          provider.clearProductSearch();
                        },
                      )
                    : null,
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Visibility(
          visible: isIconClose,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: const BorderRadius.all(
                Radius.circular(6),
              ),
              border: Border.all(
                color: Colors.grey, // Màu viền
                width: 0.3, // Độ dày viền
              ),
            ),
            child: IconButton(
              onPressed: () {
                _showBottomSheet(context, widget._controllerSearch.text);
              },
              icon: const Icon(CupertinoIcons.slider_horizontal_3),
            ),
          ),
        ),
      ],
    );
  }
}
