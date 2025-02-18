class Message {
  final String msg;
  final MessageType msgType;

  const Message({required this.msg, required this.msgType});
}

enum MessageType { user, bot }
