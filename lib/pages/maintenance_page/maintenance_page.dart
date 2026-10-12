import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenance_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Страница ТО'),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_maintenance_button',
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReminderPage(),
            ),
          );
        },
        child: const Icon(Icons.add, size: 31,),
      ),
    );
  }
}