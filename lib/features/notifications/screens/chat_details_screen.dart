import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/chat_provider.dart';
import '../../../models/chat_model.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String chatRoomId;
  const ChatDetailsScreen({super.key, required this.chatRoomId});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final room = chatProvider.getChatRoom(widget.chatRoomId);

    if (room == null) return const Scaffold(body: Center(child: Text('Chat not found')));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.gray200,
                  backgroundImage: NetworkImage(room.otherUserAvatar),
                ),
                if (room.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).colorScheme.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.otherUserName, 
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                  ),
                  Text(
                    room.isOnline ? 'Active Now' : 'Offline', 
                    style: AppTextStyles.bodySmall.copyWith(color: room.isOnline ? Colors.green : Theme.of(context).textTheme.bodySmall?.color),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call_outlined, color: Theme.of(context).iconTheme.color), 
            onPressed: () {}
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color), 
            onPressed: () {}
          ),
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              itemCount: room.messages.length,
              itemBuilder: (context, index) {
                final msg = room.messages[index];
                final isLastInGroup = index == room.messages.length - 1 || room.messages[index + 1].senderId != msg.senderId;
                return _buildMessageBubble(msg, isLastInGroup);
              },
            ),
          ),
          _buildInputArea(context, chatProvider),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message msg, bool isLastInGroup) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            if (isLastInGroup)
              CircleAvatar(radius: 14, backgroundImage: NetworkImage(msg.senderAvatar))
            else
              const SizedBox(width: 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: msg.isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(msg.isMe ? 16 : 4),
                      bottomRight: Radius.circular(msg.isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isMe ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color, 
                      fontSize: 15
                    ),
                  ),
                ),
                if (isLastInGroup)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Text(
                      DateFormat('h:mm a').format(msg.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ),
              ],
            ),
          ),
          if (msg.isMe) ...[
            const SizedBox(width: 8),
            if (isLastInGroup)
              CircleAvatar(radius: 14, backgroundImage: NetworkImage(msg.senderAvatar))
            else
              const SizedBox(width: 28),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary), 
              onPressed: () {}
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: TextField(
                controller: _messageController,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Theme.of(context).disabledColor),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  fillColor: Colors.transparent,
                ),
                onSubmitted: (val) => _send(provider),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _send(provider),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _send(ChatProvider provider) {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      provider.sendMessage(widget.chatRoomId, text);
      _messageController.clear();
      _scrollToBottom();
    }
  }
}
