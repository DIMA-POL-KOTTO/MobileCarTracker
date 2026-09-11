import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(l10n.english_lang, style: TextStyle(color: AppTheme.textSecondaryColor)),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            onTap: () {
              // Позже добавим выбор языка
            },
          ),

          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(l10n.light, style: TextStyle(color: AppTheme.textSecondaryColor),),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            
            onTap: () {
              // Позже добавим выбор темы
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            onTap: () {
              // Позже добавим настройки уведомлений
            },
          ),
        ],
      ),
    );
  }
}
