import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/pages/more_page/settings_page.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.more_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(l10n.settings),
            trailing: const Icon(Icons.chevron_right),
            iconColor: AppTheme.textSecondaryColor,
            textColor: AppTheme.textColor,
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}