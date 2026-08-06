import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';

enum ChatCategory { rider, support, marketplace, all }

class ChatProvider extends ChangeNotifier {
  final List<ChatRoom> _chatRooms = [
    ChatRoom(
      id: 'support',
      otherUserName: 'EcoConnect Support',
      otherUserAvatar: 'https://i.pravatar.cc/150?img=1',
      isOnline: true,
      messages: [
        Message(
          id: 'm1',
          senderId: 'support',
          senderName: 'Support',
          senderAvatar: 'https://i.pravatar.cc/150?img=1',
          text: 'Hello! I am your EcoConnect Assistant. How can I help you today?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isMe: false,
        ),
      ],
    ),
    ChatRoom(
      id: 'r1',
      otherUserName: 'Marcus Chen',
      otherUserAvatar: 'https://i.pravatar.cc/150?img=11',
      messages: [
        Message(
          id: 'm2',
          senderId: 'marcus',
          senderName: 'Marcus',
          senderAvatar: 'https://i.pravatar.cc/150?img=11',
          text: "I've arrived at the collection point.",
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isMe: false,
        ),
      ],
    ),
  ];

  List<ChatRoom> get chatRooms => _chatRooms;

  List<ChatRoom> getFilteredRooms(ChatCategory category) {
    if (category == ChatCategory.all) return _chatRooms;
    if (category == ChatCategory.support) return _chatRooms.where((r) => r.id == 'support').toList();
    if (category == ChatCategory.rider) return _chatRooms.where((r) => r.id.startsWith('r')).toList();
    if (category == ChatCategory.marketplace) return _chatRooms.where((r) => r.id.startsWith('m')).toList();
    return _chatRooms;
  }

  ChatRoom? getChatRoom(String id) {
    try {
      return _chatRooms.firstWhere((room) => room.id == id);
    } catch (_) {
      return null;
    }
  }

  void sendMessage(String roomId, String text) {
    final room = getChatRoom(roomId);
    if (room != null) {
      room.messages.add(Message(
        id: DateTime.now().toString(),
        senderId: 'me',
        senderName: 'Me',
        senderAvatar: 'https://i.pravatar.cc/150?img=12',
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      notifyListeners();

      if (roomId == 'support') {
        _handleSupportBotResponse(text);
      }
    }
  }

  void _handleSupportBotResponse(String userText) {
    String response = "I'm not sure about that. Would you like me to connect you with a human agent?";
    final query = userText.toLowerCase();

    if (query.contains('pickup') || query.contains('request')) {
      response = "To request a pickup, tap the 'Request Pickup' button on your Home screen, select the waste type, and confirm your location.";
    } else if (query.contains('recycle') || query.contains('material')) {
      response = "We recycle plastic (PET, HDPE), paper, metals, and glass. Check our 'Tips' section for detailed guides!";
    } else if (query.contains('payment') || query.contains('momo') || query.contains('om')) {
      response = "We support Mobile Money (MoMo), Orange Money (OM), and Cash on Delivery for marketplace purchases.";
    } else if (query.contains('rider')) {
      response = "Riders are assigned automatically once you create a request. You'll be notified as soon as one accepts.";
    } else if (query.contains('password') || query.contains('account')) {
      response = "You can change your password or update your profile in the 'Settings' section under your Profile tab.";
    }

    Timer(const Duration(seconds: 1), () {
      final room = getChatRoom('support');
      room?.messages.add(Message(
        id: DateTime.now().toString(),
        senderId: 'support',
        senderName: 'Support',
        senderAvatar: 'https://i.pravatar.cc/150?img=1',
        text: response,
        timestamp: DateTime.now(),
        isMe: false,
      ));
      notifyListeners();
    });
  }
}
