import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_hand_store/screens/tabs/message_tab.dart';
import 'package:second_hand_store/screens/tabs/notification_tab.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
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
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10),
                child: ButtonsTabBar(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                child: TabBarView(physics: BouncingScrollPhysics(), children: [
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
        ),
      ),
    );
  }
}
