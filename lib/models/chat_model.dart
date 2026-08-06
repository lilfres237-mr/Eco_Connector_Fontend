class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String senderAvatar;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatRoom {
  final String id;
  final String otherUserName;
  final String otherUserAvatar;
  final List<Message> messages;
  final bool isOnline;

  ChatRoom({
    required this.id,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.messages,
    this.isOnline = false,
  });
}
