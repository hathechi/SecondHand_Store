import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/api_services/product_service.dart';
import 'package:second_hand_store/models/danhmuc.dart';
import 'package:second_hand_store/models/sanpham.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/screens/pages/profile_page.dart';
import 'package:second_hand_store/utils/push_screen.dart';
import 'package:second_hand_store/utils/show_toast.dart';
import '../api_services/upload_service.dart';
import '../permission/permission.dart';
import '../provider/category_provider.dart';
import '../utils/colors.dart';
import '../utils/shared_preferences.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key, this.sanPham});

  @override
  State<AddProduct> createState() => _AddProductState();
  final SanPham? sanPham;
}

class _AddProductState extends State<AddProduct> {
  final _controllerName = TextEditingController();
  final _controllerMota = TextEditingController();
  final _controllerGia = TextEditingController();
  final _controllerSDT = TextEditingController();
  final _controllerDiachi = TextEditingController();

  //key
  final formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  String? selectedOption_thuonghieu;

  //getImage
  int selectedCount = 0; //lấy vị trí của ảnh trong mảng
  List<XFile> selectedImages = [];
  final picker = ImagePicker();

  //List image push từ detail qua
  List<String> listImageFromDetail = [];
  //biến kiểm tra xem là update hay insert
  bool isUpdate = false;

  //error text dropdown
  String? _errorMessage;

  //bool check xem đã chọn hình hay chưa
  bool _errChoiceImage = false;

  Future<void> pickImageFromGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    if (pickedFile != null) {
      log(pickedFile.path);
      setState(() {
        selectedImages.add(XFile(pickedFile.path));
      });
    }
  }

  void _pushDataController(SanPham sanPham) {
    _controllerName.text = sanPham.tenSanpham!;
    _controllerDiachi.text = sanPham.diachi!;
    _controllerGia.text = sanPham.gia!.toString();
    _controllerMota.text = sanPham.moTa!;
    _controllerSDT.text = sanPham.sdt!;
    selectedOption_thuonghieu = sanPham.idDanhmuc!.toString();
    //sao chép mảng thành mảng mới
    listImageFromDetail = List.from(sanPham.imageArr!);
    //nếu có dữ liệu chuyển biến check update thành true để đổi chức năng khi truy cập trang detail
    isUpdate = true;
  }

  @override
  void initState() {
    super.initState();
    //Lấy dữ liệu của toàn bộ danh mục qua provider
    final providerCategory =
        Provider.of<CategoryProvider>(context, listen: false);
    providerCategory.getAll();

    if (widget.sanPham != null) {
      _pushDataController(widget.sanPham!);
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
          child: Form(
            key: formKey,
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
                  height: 72,
                  child: TextFormField(
                    controller: _controllerName,
                    validator: (value) {
                      if (value == '') {
                        return "Không bỏ trống";
                      }
                      if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value!)) {
                        return 'Không chứa kí tự đặc biệt';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              //khi sửa sản phẩm, hiển thị image lên listview
                              if (index < listImageFromDetail.length) {
                                return Container(
                                  width: 90,
                                  height: 90,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        "${dotenv.env['URL_IMAGE']}${listImageFromDetail[index]}",
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
                                              listImageFromDetail
                                                  .removeAt(index);
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
                              }
                              //khi chọn sản phẩm từ thư viện rồi hiển thị lên listview
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
                                      color: _errChoiceImage
                                          ? Colors.red
                                          : Colors.black,
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
                        height: 72,
                        child: Consumer<CategoryProvider>(
                          builder: (context, provider, child) {
                            return DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _errorMessage = 'Vui lòng chọn một mục';
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = null;
                                  });
                                }
                                return null;
                              },
                              value: selectedOption_thuonghieu,
                              onChanged: (value) {
                                setState(() {
                                  log(value.toString());
                                  selectedOption_thuonghieu = value;
                                });
                              },
                              onSaved: (value) {
                                setState(() {
                                  selectedOption_thuonghieu = value;
                                });
                              },
                              decoration: InputDecoration(
                                  errorText: _errorMessage,
                                  contentPadding:
                                      const EdgeInsets.only(left: 10),
                                  alignLabelWithHint: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0.2),
                                      borderRadius: BorderRadius.circular(6)),
                                  hintText: 'Chọn danh mục',
                                  hintStyle: const TextStyle(fontSize: 15),
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0.2),
                                      borderRadius: BorderRadius.circular(6))),
                              items: provider.danhmucs.map((DanhMuc option) {
                                return DropdownMenuItem<String>(
                                  value: option.idDanhmuc.toString(),
                                  child: Text(option.tenDanhmuc!),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Giá',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 72,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không bỏ trống";
                            }
                            if (RegExp(r'[!@#\$%^&*(),?":{}|<>]')
                                .hasMatch(value)) {
                              return 'Không chứa kí tự đặc biệt';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _controllerGia,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Giá',
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không bỏ trống";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
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
                        height: 72,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          controller: _controllerSDT,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không bỏ trống";
                            } else if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]')
                                .hasMatch(value)) {
                              return 'Không chứa kí tự đặc biệt';
                            } else if (value.length < 10) {
                              return 'Nhập đủ độ dài số điện thoại';
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
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
                        height: 72,
                        child: TextFormField(
                          maxLines: 3,
                          controller: _controllerDiachi,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Không bỏ trống";
                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never),
                        ),
                      ),
                    ],
                  ),
                ),
                !isUpdate
                    ? btnSubmit(
                        title: 'Đăng sản phẩm',
                        onTap: () async {
                          //Kiểm tra xem đã chọn hình hay chưa
                          if (listImageFromDetail.isEmpty &&
                              selectedImages.isEmpty) {
                            setState(() {
                              _errChoiceImage = true;
                            });
                          } else {
                            setState(() {
                              _errChoiceImage = false;
                            });
                          }
                          if (!_errChoiceImage &&
                              formKey.currentState!.validate() &&
                              selectedOption_thuonghieu != null) {
                            //đầy đủ các yêu cầu thì thực hiện chức năng

                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.showLoading();
                            var id = await getFromLocalStorage('user');

                            var url =
                                // ignore: use_build_context_synchronously
                                await uploadImages(selectedImages, context);
                            if (url.isNotEmpty && id != null) {
                              var now = DateTime.now();
                              var ngayTao = now.millisecondsSinceEpoch;
                              var sanPham = SanPham(
                                  tenSanpham: _controllerName.text,
                                  idNguoidung: id['id_nguoidung'],
                                  idDanhmuc:
                                      int.parse(selectedOption_thuonghieu!),
                                  ngayTao: ngayTao,
                                  gia: double.parse(_controllerGia.text),
                                  sdt: _controllerSDT.text,
                                  diachi: _controllerDiachi.text,
                                  moTa: _controllerMota.text,
                                  status: false,
                                  imageArr: url);

                              // ignore: use_build_context_synchronously
                              postData(sanPham, context);
                              provider.dismiss();
                            }
                          }
                        },
                      )
                    : btnSubmit(
                        title: 'Sửa sản phẩm',
                        onTap: () async {
                          //Kiểm tra xem đã chọn hình hay chưa
                          if (listImageFromDetail.isEmpty &&
                              selectedImages.isEmpty) {
                            setState(() {
                              _errChoiceImage = true;
                            });
                          } else {
                            setState(() {
                              _errChoiceImage = false;
                            });
                          }
                          if (!_errChoiceImage &&
                              formKey.currentState!.validate() &&
                              selectedOption_thuonghieu != null) {
                            //đầy đủ các yêu cầu thì thực hiện chức năng

                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.showLoading();
                            // var id = await getFromLocalStorage('user');
                            List<String> url = [];
                            if (selectedImages.isNotEmpty) {
                              // ignore: use_build_context_synchronously
                              url = await uploadImages(selectedImages, context);
                            } else {
                              url = listImageFromDetail;
                            }
                            if (url.isNotEmpty) {
                              var sanPham = SanPham(
                                idSanpham: widget.sanPham!.idSanpham,
                                tenSanpham: _controllerName.text,
                                idNguoidung: widget.sanPham!.idNguoidung,
                                idDanhmuc:
                                    int.parse(selectedOption_thuonghieu!),
                                ngayTao: widget.sanPham!.ngayTao,
                                gia: double.parse(
                                    (_controllerGia.text).toString()),
                                sdt: _controllerSDT.text,
                                diachi: _controllerDiachi.text,
                                moTa: _controllerMota.text,
                                status: widget.sanPham!.status,
                                imageArr: url,
                              );

                              // ignore: use_build_context_synchronously
                              updateData(sanPham, context);
                              provider.dismiss();
                            }
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class btnSubmit extends StatelessWidget {
  const btnSubmit({
    super.key,
    required this.onTap,
    required this.title,
  });

  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
        ),
        onPressed: () async {
          onTap();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void postData(SanPham sanPham, BuildContext context) async {
  final insert = await ProductService.postData(sanPham);
  if (insert) {
    // ignore: use_build_context_synchronously
    showSnackbar(context, "Thêm sản phẩm thành công", Colors.green);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}

void updateData(SanPham sanPham, BuildContext context) async {
  final update = await ProductService.updateData(sanPham);
  if (update) {
    // ignore: use_build_context_synchronously
    showSnackbar(context, "Sửa sản phẩm thành công", Colors.green);
    // ignore: use_build_context_synchronously
    pushReplacement(context, const ProfilePage());
  }
}
