import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/api_services/socket.io_service.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:second_hand_store/screens/tabs/message_tab.dart';
import 'package:second_hand_store/screens/tabs/notification_tab.dart';

import '../../utils/shared_preferences.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  bool isLogin = false;
  void connectAndGetConversation(BuildContext context) async {
    //Gọi hàm kết nối với Socket và hàm lắng nghe sự kiện tin nhắn được trả về
    await SocketService.connectToSocket();
    var userId = await getFromLocalStorage('user');

    if (userId != null) {
      // ignore: use_build_context_synchronously
      await SocketService.getConversationToDatabase(
          nguoigui: userId['id_nguoidung'], context: context);
    }

    // ignore: use_build_context_synchronously
    SocketService.listenForMessages(context);
  }

  @override
  void initState() {
    super.initState();
    connectAndGetConversation(context);
  }

  @override
  void dispose() {
    super.dispose();
    SocketService.disconnectFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Tin nhắn & thông báo',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: provider.isLogged
            ? DefaultTabController(
                length: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: ButtonsTabBar(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.25),
                        ),
                        unselectedDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        // Add your tabs here
                        tabs: const [
                          Tab(
                            text: 'Tin nhắn',
                            icon: Icon(
                              CupertinoIcons.captions_bubble,
                              size: 18,
                            ),
                          ),
                          Tab(
                            text: 'Thông báo',
                            icon: Icon(
                              CupertinoIcons.speaker_zzz,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Center(
                              child: MessageTab(),
                            ),
                            Center(
                              child: NotificationTab(),
                            ),
                          ]),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      'Bạn cần đăng nhập để xem tin nhắn & thông báo 🐧'),
                  Center(
                    child: Lottie.asset('assets/images/nodata.json'),
                  ),
                ],
              ),
      ),
    );
  }
}
