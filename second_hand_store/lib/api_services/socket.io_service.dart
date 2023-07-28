import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/message_provider.dart';
import 'package:second_hand_store/screens/room_chat_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static io.Socket? socket;
  // Địa chỉ URL của server Socket.IO
  static String socketUrl =
      'http://${dotenv.env["IPV4"]}:${dotenv.env["PORT"]}/';

  static Future<void> disconnectFromServer() async {
    socket?.dispose();
    socket = null;
  }

  static io.Socket? getSocketInstance() {
    return socket;
  }

// Hàm để kết nối socket khi ứng dụng khởi động
  static Future<void> connectToSocket() async {
    socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      log('Đã kết nối tới server Socket.IO ');
    });

    socket!.onConnectError((data) {
      log('Connect error: $data');
    });
  }

// Hàm để gửi tin nhắn lên server khi người dùng ấn nút gửi
  static void sendMessage(
      {required String content,
      required int nguoigui,
      required int nguoinhan,
      required BuildContext context}) {
    // Gửi sự kiện 'send message' với dữ liệu từ TextField

    socket!.emit('send message', {
      'message': content,
      'id_nguoigui': nguoigui,
      'id_nguoinhan': nguoinhan,
      'socketId': socket!.id,
    });
  }

// Lắng nghe sự kiện "chat message" và xử lý tin nhắn trả về từ server
  static void listenForMessages(BuildContext context) {
    final provider = Provider.of<MessageProvider>(context, listen: false);

    socket!.on('chat message', (data) {
      if (data['socketId'] == socket!.id) {
        provider.addMessage(
            Message(isSentByMe: true, content: data['message']['message']));
        log(data['message']['message'] + " isSentByMe: true");
      } else {
        provider.addMessage(
            Message(isSentByMe: false, content: data['message']['message']));
        log(data['message']['message'] + " isSentByMe: false");
      }
    });
  }

  static Future<void> getChatHistory(
      {int? nguoigui, int? nguoinhan, required BuildContext context}) async {
    final provider = Provider.of<MessageProvider>(context, listen: false);
    provider.showLoading();
    socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });
    socket!.onConnect((_) {
      log('Đã kết nối tới server Socket.IO - getChatHistory + ${socket!.id} ');

      socket!.emit('get chat history', {
        'nguoigui': nguoigui,
        "nguoinhan": nguoinhan,
        'socketId': socket!.id
      });

      socket!.on('chat history', (data) {
        List<Message> history = [];

        (data['message']).forEach((item) => {
              history.add(Message(
                  isSentByMe: item['id_nguoigui'] == nguoigui ? true : false,
                  content: item['message']))
            });
        if (data['socketId'] == socket!.id) {
          provider.listMessage = history;
          provider.dismiss();
        }
      });
    });
  }

  static void saveConversationToDatabase(
      {required int nguoigui, required int nguoinhan}) async {
    socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!
        .emit('save conversation', {'userId1': nguoigui, 'userId2': nguoinhan});
  }

  static Future getConversationToDatabase(
      {required int nguoigui, required BuildContext context}) async {
    socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
    });

    socket!.onConnect((_) {
      log('Đã kết nối tới server Socket.IO - getConversationToDatabase ${socket!.id} ');

      socket!.emit(
          'get conversation', {'userId1': nguoigui, "socketId": socket!.id});

      socket!.on('get conversation', (data) {
        final provider = Provider.of<MessageProvider>(context, listen: false);
        provider.showLoading();
        if (data['socketId'] == socket!.id) {
          provider.listConversation = data['message'][0];

          data['message'].forEach((item) => {print("Danh Sách: $item")});
          provider.dismiss();
        }
      });
    });
  }
}
