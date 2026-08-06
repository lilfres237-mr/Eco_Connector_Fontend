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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'isMe': isMe,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
      isMe: json['isMe'],
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserName': otherUserName,
      'otherUserAvatar': otherUserAvatar,
      'messages': messages.map((m) => m.toJson()).toList(),
      'isOnline': isOnline,
    };
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      otherUserName: json['otherUserName'],
      otherUserAvatar: json['otherUserAvatar'],
      messages: (json['messages'] as List).map((m) => Message.fromJson(m)).toList(),
      isOnline: json['isOnline'] ?? false,
    );
  }
}
