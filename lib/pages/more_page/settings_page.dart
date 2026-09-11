import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),

      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Язык'),
            subtitle: const Text('Русский', style: TextStyle(color: AppTheme.textSecondaryColor)),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            onTap: () {
              // Позже добавим выбор языка
            },
          ),

          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Тема'),
            subtitle: const Text('Светлая', style: TextStyle(color: AppTheme.textSecondaryColor),),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            
            onTap: () {
              // Позже добавим выбор темы
            },
          ),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Уведомления'),
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
