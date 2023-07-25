import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/provider/product_provider.dart';
import 'package:second_hand_store/screens/add_product.dart';
import 'package:second_hand_store/utils/cache_image.dart';
import 'package:second_hand_store/utils/push_screen.dart';
import 'package:second_hand_store/utils/shared_preferences.dart';

import '../detail_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, this.controller});
  final PersistentTabController? controller;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // ignore: use_build_context_synchronously
    final provider = Provider.of<ProductProvider>(context, listen: false);
    //Lấy dữ liệu những sản phẩm đã thêm theo id người dùng
    _getID().then((value) => provider.getAllProductWithID(id: value));
  }

  Future<String> _getID() async {
    var user = await getFromLocalStorage('user');
    return user['id_nguoidung'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          return Future<void>.delayed(
            const Duration(milliseconds: 500),
            () {
              final provider =
                  Provider.of<ProductProvider>(context, listen: false);
              //Lấy dữ liệu những sản phẩm đã thêm theo id người dùng
              _getID().then((value) => provider.getAllProductWithID(id: value));
              setState(() {});
            },
          );
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                Positioned(
                  left: -20,
                  right: -20,
                  child: Lottie.asset(
                    'assets/images/ani_profile.json',
                    fit: BoxFit.cover,
                    height: 170,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 30,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        child: IconButton(
                          onPressed: () {
                            widget.controller!.jumpToTab(0);
                          },
                          icon: const Icon(
                            CupertinoIcons.home,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.black.withOpacity(0.7),
                        child: PopupMenuButton<String>(
                          offset: const Offset(0, 60),
                          icon: const Icon(
                            CupertinoIcons.ellipsis_vertical,
                            color: Colors.white,
                          ),
                          onSelected: (String value) {
                            if (value == 'logout') {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.logoutGoogle();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'logout',
                              child: Text('Đăng xuất'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 120,
                  right: 20,
                  left: 20,
                  child: Card(
                    color: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: SizedBox(
                      height: 160,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          provider.user!.photoURL != null
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(provider.user!.photoURL!),
                                )
                              : const CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      AssetImage('assets/images/avatar.png'),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.user!.displayName ?? "",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                provider.user!.email ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(),
                              const Row(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.person_badge_plus,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text('0'),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.cart_badge_minus,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Đã bán 0',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.star_fill,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Chưa có',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 10,
                  right: 10,
                  bottom: 0,
                  child: Consumer<ProductProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return value.sanphamWithId.isNotEmpty
                          ? GridView.builder(
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 260,
                              ),
                              itemCount: value.sanphamWithId.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding:
                                      const EdgeInsets.only(right: 6, left: 6),
                                  child: InkWell(
                                    onTap: () {
                                      pushScreen(
                                        context,
                                        DetailScreen(
                                            sanphams:
                                                value.sanphamWithId[index],
                                            saleOrEdit: false),
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
                                                    '${dotenv.env["URL_IMAGE"]}${value.sanphamWithId[index].imageArr![0]}',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                  ),
                                                ),
                                              );
                                            }),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Text(
                                                  '${value.sanphamWithId[index].danhmuc}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            '${value.sanphamWithId[index].gia}k vnđ',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Lottie.asset('assets/images/nodata.json'),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          pushScreen(context, const AddProduct());
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
