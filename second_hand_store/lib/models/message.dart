class Message {
  final bool isSentByMe;
  final String content;
  final int id_message;
  final String time;

  Message(
      {required this.isSentByMe,
      required this.content,
      required this.id_message,
      required this.time});
}
