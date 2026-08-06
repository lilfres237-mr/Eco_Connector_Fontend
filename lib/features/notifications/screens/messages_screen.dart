import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/app_logo.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/chat_provider.dart';
import '../../../core/routes/app_routes.dart';
import 'chat_details_screen.dart';
import '../../../core/constants/app_images.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  ChatCategory _selectedCategory = ChatCategory.all;

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final rooms = chatProvider.getFilteredRooms(_selectedCategory);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppLogo(variant: LogoVariant.icon),
        ),
        title: Text(
          'Messages',
          style: AppTextStyles.h3.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          const SizedBox(width: 8),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          _buildFilters(context),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                final lastMessage = room.messages.last;
                return _buildChatItem(
                  context,
                  roomId: room.id,
                  imageUrl: room.otherUserAvatar,
                  name: room.otherUserName,
                  message: lastMessage.text,
                  time: '10:24 AM', // Simplified
                  isUnread: room.messages.any((m) => !m.isMe), // Simple logic
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.edit_note, color: Colors.white, size: 28),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(context, 'All', ChatCategory.all),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Riders', ChatCategory.rider),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Support', ChatCategory.support),
            const SizedBox(width: 8),
            _buildFilterChip(context, 'Market', ChatCategory.marketplace),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, ChatCategory category) {
    bool isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : (Theme.of(context).dividerTheme.color ?? AppColors.gray200)),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(
    BuildContext context, {
    required String roomId,
    required String imageUrl,
    required String name,
    required String message,
    required String time,
    bool isUnread = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ChatDetailsScreen(chatRoomId: roomId)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1), width: 0.5)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(context).cardTheme.color,
              backgroundImage: AssetImage(AppImages.getSafeImage(imageUrl, fallback: AppImages.avatarPlaceholder)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isUnread ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
