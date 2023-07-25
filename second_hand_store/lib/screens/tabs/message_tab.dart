import 'package:flutter/material.dart';
import 'package:second_hand_store/screens/room_chat_screen.dart';
import 'package:second_hand_store/utils/push_screen.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => pushScreen(context, const RoomChatScreen()),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Uncle K',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          '30 phút trước',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
