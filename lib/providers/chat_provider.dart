import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/storage_service.dart';
import '../core/constants/app_images.dart';

enum ChatCategory { rider, support, marketplace, all }

class ChatProvider extends ChangeNotifier {
  List<ChatRoom> _chatRooms = [];

  ChatProvider() {
    _loadChatRooms();
  }

  void _loadChatRooms() {
    final chatJson = StorageService.getString('user_chats');
    if (chatJson != null && chatJson.isNotEmpty) {
      final List<dynamic> decoded = json.decode(chatJson);
      _chatRooms = decoded.map((c) => ChatRoom.fromJson(c)).toList();
    } else {
      _chatRooms = [
        ChatRoom(
          id: 'support',
          otherUserName: 'EcoConnect Support',
          otherUserAvatar: AppImages.avatarPlaceholder,
          isOnline: true,
          messages: [
            Message(
              id: 'm1',
              senderId: 'support',
              senderName: 'Support',
              senderAvatar: AppImages.avatarPlaceholder,
              text: 'Hello! I am your EcoConnect Assistant. How can I help you today?',
              timestamp: DateTime.now().subtract(const Duration(hours: 1)),
              isMe: false,
            ),
          ],
        ),
        ChatRoom(
          id: 'r1',
          otherUserName: 'Marcus Chen',
          otherUserAvatar: AppImages.avatarPlaceholder,
          messages: [
            Message(
              id: 'm2',
              senderId: 'marcus',
              senderName: 'Marcus',
              senderAvatar: AppImages.avatarPlaceholder,
              text: "I've arrived at the collection point.",
              timestamp: DateTime.now().subtract(const Duration(days: 1)),
              isMe: false,
            ),
          ],
        ),
      ];
      _saveChatRooms();
    }
    notifyListeners();
  }

  Future<void> _saveChatRooms() async {
    final chatJson = json.encode(_chatRooms.map((c) => c.toJson()).toList());
    await StorageService.setString('user_chats', chatJson);
  }

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
        senderAvatar: AppImages.avatarPlaceholder,
        text: text,
        timestamp: DateTime.now(),
        isMe: true,
      ));
      _saveChatRooms();
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
        senderAvatar: AppImages.avatarPlaceholder,
        text: response,
        timestamp: DateTime.now(),
        isMe: false,
      ));
      _saveChatRooms();
      notifyListeners();
    });
  }
}
