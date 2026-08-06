import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers/settings_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/auth_provider.dart';

import '../../../core/routes/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.settings,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle(context, l10n.general),
          _buildSwitchTile(
            context,
            l10n.notifications,
            'Receive alerts about your pickups',
            settings.notificationsEnabled,
            (val) => settings.toggleNotifications(val),
          ),
          _buildSwitchTile(
            context,
            l10n.darkMode,
            'Toggle application theme',
            settings.darkMode,
            (val) => settings.toggleDarkMode(val),
          ),
          _buildLanguageTile(context, l10n, settings),
          Divider(height: 48, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          _buildSectionTitle(context, 'Privacy & Security'),
          _buildListTile(context, l10n.privacyPolicy, () => Navigator.pushNamed(context, AppRoutes.privacyPolicy)),
          _buildListTile(context, l10n.termsOfService, () => Navigator.pushNamed(context, AppRoutes.termsOfService)),
          _buildListTile(context, l10n.changePassword, () {}),
          Divider(height: 48, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          _buildSectionTitle(context, 'Account'),
          _buildListTile(context, l10n.deleteAccount, () {}, isDestructive: true),
          _buildListTile(
            context,
            l10n.logout,
            () async {
              final authProvider = context.read<AuthProvider>();
              final userProvider = context.read<UserProvider>();
              await authProvider.logout();
              if (!context.mounted) return;
              await userProvider.setUser(null);
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, bool value, Function(bool) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppLocalizations l10n, SettingsProvider settings) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        l10n.language,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      subtitle: Text(
        settings.language == AppLanguage.english ? l10n.english : l10n.french,
        style: AppTextStyles.bodySmall.copyWith(
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      trailing: Icon(Icons.language, color: Theme.of(context).colorScheme.primary),
      onTap: () => _showLanguageDialog(context, l10n, settings),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ignore: deprecated_member_use
            RadioListTile<AppLanguage>.adaptive(
              title: Text(l10n.english),
              value: AppLanguage.english,
              // ignore: deprecated_member_use
              groupValue: settings.language,
              activeColor: Theme.of(context).colorScheme.primary,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  settings.setLanguage(val);
                }
                Navigator.pop(context);
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<AppLanguage>.adaptive(
              title: Text(l10n.french),
              value: AppLanguage.french,
              // ignore: deprecated_member_use
              groupValue: settings.language,
              activeColor: Theme.of(context).colorScheme.primary,
              // ignore: deprecated_member_use
              onChanged: (val) {
                if (val != null) {
                  settings.setLanguage(val);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.bold,
          color: isDestructive ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).dividerTheme.color ?? AppColors.gray300),
      onTap: onTap,
    );
  }
}
