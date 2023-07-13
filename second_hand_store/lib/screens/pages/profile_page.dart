import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/screens/add_product.dart';
import 'package:second_hand_store/utils/push_screen.dart';

import '../../utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.controller});
  final PersistentTabController controller;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Image.asset(
              'assets/images/br_profile.jpg',
              fit: BoxFit.cover,
              height: 170,
              width: double.infinity,
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
                        widget.controller.jumpToTab(0);
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
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
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
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 260,
                ),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(right: 6, left: 6),
                    child: InkWell(
                      onTap: () {
                        // pushScreen(
                        //   context,
                        //   DetailScreen(
                        //     sanphams: value.sanphams[index],
                        //   ),
                        // );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Builder(builder: (context) {
                                return SizedBox(
                                  height: 200,
                                  // width: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      'https://cdn-img-v2.webbnc.net/uploadv2/web/80/8040/media/2021/08/10/10/28/1628563731_chup-man-hinh-macbook-3.jpeg',
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
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'Khác',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: const Text(
                              '20.000đ',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
//  ElevatedButton(
//                   onPressed: () {
//                     final provider = Provider.of<GoogleSignInProvider>(context,
//                         listen: false);
//                     provider.logoutGoogle();
//                   },
//                   child: const Text('Log Out'))
