import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/google_signin.dart';

import '../api_services/upload_service.dart';
import '../permission/permission.dart';
import '../utils/colors.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _controllerName = TextEditingController();
  final _controllerMota = TextEditingController();
  final _controllerSDT = TextEditingController();
  final _controllerDiachi = TextEditingController();
  // ignore: non_constant_identifier_names
  String? selectedOption_thuonghieu;

  List<String> options = ['Đồ gia dụng', 'Đồ điện tử', 'Quần áo cũ', 'Khác'];

  //getImage
  int selectedCount = 0; //lấy vị trí của ảnh trong mảng
  List<XFile> selectedImages = [];
  final picker = ImagePicker();

  Future<void> pickImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      log(pickedFile.path);
      setState(() {
        selectedImages.add(XFile(pickedFile.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            CupertinoIcons.xmark,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  provider.user!.photoURL != null
                      ? CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              NetworkImage(provider.user!.photoURL!),
                        )
                      : const CircleAvatar(
                          radius: 24,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.user!.displayName ?? "",
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        "Bán gì hôm nay?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.6),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 54,
                child: TextFormField(
                  controller: _controllerName,
                  decoration: const InputDecoration(
                      hintText: 'Nhập tên sản phẩm muốn bán ',
                      alignLabelWithHint: true,
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding: EdgeInsets.only(left: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thêm hình ảnh',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      'Tối thiểu 1 ảnh',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            if (index < selectedCount) {
                              // Hiển thị hình ảnh trong các ô đã chọn
                              return Container(
                                width: 90,
                                height: 90,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                      File(selectedImages[index].path),
                                    ),
                                  ),
                                ),
                                child: Stack(children: [
                                  Positioned(
                                    top: -5,
                                    right: -5,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            selectedCount--;
                                            selectedImages.removeAt(index);
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.clear_circled_solid,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            } else {
                              // Hiển thị ô chọn hình ảnh
                              return InkWell(
                                onTap: () async {
                                  if (await requestPermission()) {
                                    final pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery,
                                        imageQuality: 50);
                                    if (pickedFile != null) {
                                      setState(() {
                                        selectedCount++;
                                        selectedImages
                                            .add(XFile(pickedFile.path));
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 12),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(8),
                                    dashPattern: const [5, 3],
                                    child: const Center(
                                        child: Icon(CupertinoIcons.camera)),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                color: secondaryColor,
                width: double.infinity,
                height: 6,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi tiết sản phẩm',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Danh mục',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: DropdownButtonFormField<String>(
                        value: selectedOption_thuonghieu,
                        onChanged: (value) {
                          setState(() {
                            selectedOption_thuonghieu = value;
                          });
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 10),
                            alignLabelWithHint: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0.2),
                                borderRadius: BorderRadius.circular(6)),
                            hintText: 'Chọn danh mục',
                            hintStyle: const TextStyle(fontSize: 15),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0.2),
                                borderRadius: BorderRadius.circular(6))),
                        items: options.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Mô tả ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        maxLines: 5,
                        controller: _controllerMota,
                        decoration: const InputDecoration(
                            hintText: 'Nhập mô tả',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                color: secondaryColor,
                width: double.infinity,
                height: 6,
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin vận chuyển',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        controller: _controllerSDT,
                        decoration: const InputDecoration(
                            hintText: 'Số điện thoại',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding: EdgeInsets.only(left: 16),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      'Địa chỉ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFormField(
                        maxLines: 3,
                        controller: _controllerDiachi,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                            hintText: 'Địa chỉ',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(fontSize: 15),
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 54,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () {
                    uploadImages(selectedImages, context);
                  },
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng bán',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
