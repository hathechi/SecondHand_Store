import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/api_services/socket.io_service.dart';
import 'package:second_hand_store/provider/message_provider.dart';
import 'package:second_hand_store/utils/push_screen.dart';
import 'package:second_hand_store/utils/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

class RoomChatScreen extends StatefulWidget {
  RoomChatScreen({super.key, this.id_nguoinhan, this.data_nguoinhan});
  int? id_nguoinhan;
  var data_nguoinhan;
  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final _controllerSend = TextEditingController();

  //speechtotext
  final SpeechToText _speechToText = SpeechToText();
  final bool _speechEnabled = false;
  final String _lastWords = '';
  bool isListening = false;

  void getMessage(BuildContext context) async {
    var userId = await getFromLocalStorage('user');
    // ignore: use_build_context_synchronously
    await SocketService.getChatHistory(
        nguoigui: userId['id_nguoidung'],
        nguoinhan: widget.id_nguoinhan,
        context: context);
  }

  @override
  void initState() {
    super.initState();
    getMessage(context);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        leading: IconButton(
          onPressed: () => pop(context),
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  NetworkImage(widget.data_nguoinhan['url_avatar']),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.data_nguoinhan['ten'],
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14),
            ),
          ],
        ),
      ),
      body: SizedBox(
        // width: double.infinity,
        // height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Consumer<MessageProvider>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: value.listMessage.length,
                      itemBuilder: (context, index) {
                        final message = value.listMessage[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ChatMessage(
                            isSentByMe: message.isSentByMe,
                            content: message.content,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.photo),
                      ),
                      InkWell(
                        onTap: () async {
                          if (!isListening) {
                            var available = await _speechToText.initialize();
                            if (available) {
                              setState(() {
                                isListening = true;
                                _speechToText.listen(
                                  onResult: (result) {
                                    setState(() {
                                      _controllerSend.text =
                                          result.recognizedWords;
                                    });
                                  },
                                );
                              });
                            }
                          } else {
                            setState(() {
                              isListening = false;
                            });
                            _speechToText.stop();
                          }
                        },
                        child: AvatarGlow(
                          shape: BoxShape.circle,
                          glowColor: Colors.blue,
                          endRadius: 25,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          animate: isListening,
                          showTwoGlows: true,
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          child: !isListening
                              ? const Icon(CupertinoIcons.mic)
                              : const Icon(
                                  CupertinoIcons.mic_circle_fill,
                                  color: Colors.blue,
                                ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child: inputSend(
                    controllerSend: _controllerSend,
                    onTap: () async {
                      var userId = await getFromLocalStorage('user');
                      // ignore: use_build_context_synchronously
                      SocketService.sendMessage(
                          content: _controllerSend.text,
                          nguoigui: userId['id_nguoidung'],
                          nguoinhan: widget.id_nguoinhan!,
                          context: context);
                      _controllerSend.clear();
                    },
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final bool isSentByMe;
  final String content;

  const ChatMessage(
      {super.key, required this.isSentByMe, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSentByMe)
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/avatar.png'),
            ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              alignment:
                  isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSentByMe
                      ? const Color.fromARGB(255, 91, 200, 194)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: isSentByMe
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                      color: isSentByMe ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class inputSend extends StatefulWidget {
  const inputSend({
    super.key,
    required TextEditingController controllerSend,
    this.onTap,
  }) : _controllerSend = controllerSend;

  final TextEditingController _controllerSend;
  final Function? onTap;

  @override
  State<inputSend> createState() => _inputSendState();
}

class _inputSendState extends State<inputSend> {
  bool isIconClose = false;

  @override
  void initState() {
    super.initState();
    // Lắng nghe thay đổi nội dung của TextField
    widget._controllerSend.addListener(_updateIconVisibility);
  }

  @override
  void dispose() {
    widget._controllerSend.removeListener(_updateIconVisibility);
    widget._controllerSend.dispose();
    super.dispose();
  }

  void _updateIconVisibility() {
    // Kiểm tra nếu có dữ liệu trong TextField thì hiển thị icon close
    // Ngược lại, ẩn icon close
    setState(() {
      isIconClose = widget._controllerSend.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            // width: MediaQuery.sizeOf(context).width * 0.6,
            child: TextFormField(
              onFieldSubmitted: (value) {},
              onChanged: (value) {},
              controller: widget._controllerSend,
              decoration: InputDecoration(
                  hintText: 'Gửi tin nhắn',
                  alignLabelWithHint: true,
                  filled: true, // Hiển thị màu nền
                  fillColor: const Color.fromARGB(255, 244, 244, 244),
                  hintStyle: const TextStyle(fontSize: 15),
                  contentPadding: const EdgeInsets.only(left: 16),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  suffixIcon: isIconClose
                      ? IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          onPressed: () {
                            widget._controllerSend.clear();
                            _updateIconVisibility();
                          },
                        )
                      : null,
                  floatingLabelBehavior: FloatingLabelBehavior.never),
            ),
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Visibility(
          visible: isIconClose,
          child: IconButton(
            onPressed: () {
              widget.onTap!();
            },
            icon: const Icon(
              CupertinoIcons.paperplane,
              size: 30,
              color: Color.fromARGB(255, 36, 212, 186),
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
      ],
    );
  }
}

class Message {
  final bool isSentByMe;
  final String content;

  Message({required this.isSentByMe, required this.content});
}
