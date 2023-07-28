import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/message_provider.dart';
import 'package:second_hand_store/screens/room_chat_screen.dart';
import 'package:second_hand_store/utils/push_screen.dart';

import '../../api_services/socket.io_service.dart';
import '../../utils/shared_preferences.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  Future<void> getConversation(BuildContext context) async {
    var userId = await getFromLocalStorage('user');
    // ignore: use_build_context_synchronously
    final provider = Provider.of<MessageProvider>(context, listen: false);
    provider.showLoading();
    // ignore: use_build_context_synchronously
    await SocketService.getConversationToDatabase(
        nguoigui: userId['id_nguoidung'], context: context);
    provider.dismiss();
  }

  @override
  void initState() {
    super.initState();
    // getConversation(context);
  }

  @override
  void dispose() {
    SocketService.disconnectFromServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: RefreshIndicator(
          onRefresh: () async {
            return Future<void>.delayed(
              const Duration(milliseconds: 500),
              () async {
                await getConversation(context);
              },
            );
          },
          child: Consumer<MessageProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.listConversation.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => pushScreen(
                        context,
                        RoomChatScreen(
                          id_nguoinhan: value.listConversation[index]
                              ['id_nguoidung'],
                          data_nguoinhan: value.listConversation[index],
                        )),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(value
                                        .listConversation[index]['url_avatar']),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    value.listConversation[index]['ten'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Text(
                                '30 phút trước',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
