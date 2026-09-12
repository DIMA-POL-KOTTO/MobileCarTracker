import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final void Function(Locale) onChangeLanguage;

  const SettingsPage({
    super.key,
    required this.onChangeLanguage,
  });

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
            subtitle: Text(
              l10n.english_lang,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            onTap: () {
              _showLanguagePicker(context);
            },
          ),

          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(
              l10n.light,
              style: const TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),
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

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                ListTile(
                  
                  title: Text(l10n.russian_lang),
                  onTap: () {
                    onChangeLanguage(
                      const Locale('ru'),
                    );

                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  
                  title: Text(l10n.english_lang),
                  onTap: () {
                    onChangeLanguage(
                      const Locale('en'),
                    );

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}