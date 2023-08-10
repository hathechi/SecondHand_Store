// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/api_services/product_service.dart';
import 'package:second_hand_store/models/sanpham.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/screens/add_product.dart';
import 'package:second_hand_store/screens/pages/profile_page.dart';
import 'package:second_hand_store/screens/room_chat_screen.dart';
import 'package:second_hand_store/utils/push_screen.dart';
import 'package:second_hand_store/utils/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_services/socket.io_service.dart';
import '../utils/shared_preferences.dart';
import '../utils/show_bottom_sheet.dart';

// ignore: must_be_immutable
class DetailScreen extends StatefulWidget {
  DetailScreen({super.key, required this.sanphams, required this.saleOrEdit});

  final SanPham sanphams;

  //biến kiểm tra xem người dùng đến từ trang home hay trang chỉnh sửa
  late bool? saleOrEdit;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  //Kiểm tra xem mặt hàng này có phải cho người dùng đang đăng nhập đăng bán hay không? Nếu đúng thì ẩn phần liên hệ
  void checkUserisTheSeller() async {
    var userId = await getFromLocalStorage('user');
    if (userId['id_nguoidung'] == widget.sanphams.idNguoidung) {
      setState(() {
        widget.saleOrEdit = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkUserisTheSeller();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.45,
                      child: imageSlider(
                        arrImage: widget.sanphams.imageArr!,
                        onClickBack: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: AssetImage(
                                          'assets/images/avatar.png'),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        widget.sanphams.nguoidung!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: !widget.saleOrEdit!,
                                child: Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        _showBottomSheet(
                                            context, widget.sanphams);
                                      },
                                      icon: const Icon(
                                        CupertinoIcons.ellipsis_vertical,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              widget.sanphams.tenSanpham!,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text.rich(
                              TextSpan(
                                  text: 'Giá: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${widget.sanphams.gia}k vnđ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text.rich(
                              TextSpan(
                                  text: 'Danh mục: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.sanphams.danhmuc,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text.rich(
                              TextSpan(
                                  text: 'Số điện thoại: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.sanphams.sdt,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text.rich(
                              TextSpan(
                                  text: 'Địa chỉ: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.sanphams.diachi,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text.rich(
                              TextSpan(
                                  text: 'Tình trạng / Mô tả: ',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "${widget.sanphams.moTa}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: widget.saleOrEdit!,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: IconButton(
                        onPressed: () async {
                          var userId = await getFromLocalStorage('user');
                          // ignore: use_build_context_synchronously
                          if (userId != null) {
                            SocketService.saveConversationToDatabase(
                                nguoigui: userId['id_nguoidung'],
                                nguoinhan: widget.sanphams.idNguoidung!);
                            // ignore: use_build_context_synchronously
                            pushScreen(
                              context,
                              RoomChatScreen(
                                  id_nguoinhan: widget.sanphams.idNguoidung!,
                                  ten_nguoinhan: widget.sanphams.nguoidung!),
                            );
                          }
                        },
                        icon: const Icon(
                          CupertinoIcons.captions_bubble,
                          size: 34,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          onPressed: () {
                            _makePhoneCall(widget.sanphams.sdt!);
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Liên hệ người bán',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Icon(
                                CupertinoIcons.chevron_right_2,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launchUrl(launchUri);
}

void _showBottomSheet(BuildContext context, SanPham sanphams) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        height: 200,
        child: ListView(
          children: [
            btnBottomSheetItem(
              icon: const Icon(CupertinoIcons.pencil),
              title: 'Sửa sản phẩm',
              function: () {
                pop(context);

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddProduct(
                      sanPham: sanphams,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            btnBottomSheetItem(
              icon: const Icon(
                CupertinoIcons.delete,
                color: Colors.red,
              ),
              title: 'Xóa sản phẩm',
              function: () {
                // pop(context); // Khong được đóng màn ở đây, nếu đóng sẽ lỗi vì không còn context
                dialogModalBottomsheet(context, 'Xóa', () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.showLoading();
                  bool? delete =
                      await ProductService.deleteData(sanphams.idSanpham);
                  if (delete) {
                    provider.dismiss();
                    // ignore: use_build_context_synchronously
                    showToast('Xoá thành công', Colors.green);
                    // ignore: use_build_context_synchronously
                    pushAndRemoveUntil(context, const ProfilePage());
                  } else {
                    provider.dismiss();
                    // ignore: use_build_context_synchronously
                    showToast('Xoá không thành công', Colors.red);
                  }
                });
              },
            ),
          ],
        ),
      );
    },
  );
}

class btnBottomSheetItem extends StatelessWidget {
  final Icon icon;
  final String title;
  Function? function;
  btnBottomSheetItem({
    Key? key,
    required this.icon,
    required this.title,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function!();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 20,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class imageSlider extends StatefulWidget {
  const imageSlider({
    super.key,
    required this.arrImage,
    this.onClickBack,
  });

  final List arrImage;
  final Function? onClickBack;

  @override
  State<imageSlider> createState() => _imageSliderState();
}

class _imageSliderState extends State<imageSlider> {
  int _currentSlide = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.arrImage.length,
          itemBuilder: (BuildContext context, int index, int pageViewIndex) {
            return Image.network(
              '${dotenv.env["URL_IMAGE"]}${widget.arrImage[index]}',
              fit: BoxFit.cover,
            );
          },
          options: CarouselOptions(
            height: double.infinity,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentSlide = index;
              });
            },
            // autoPlay: true,
            // autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 10,
          child: DotsIndicator(
            dotsCount: widget.arrImage.length,
            position: _currentSlide,
            axis: Axis.vertical,
            reversed: false,
            decorator: const DotsDecorator(
              color: Colors.white,
              activeColor: Colors.orange,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 20,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.black.withOpacity(0.6),
            child: IconButton(
              onPressed: () {
                widget.onClickBack?.call();
              },
              icon: const Icon(
                CupertinoIcons.chevron_back,
                size: 26,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
