import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';
import 'package:car_tracker/services/maintenance_service.dart';
import 'package:car_tracker/widgets/reminder_card.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  late Future<List<Map<String, dynamic>>> _remindersFuture;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  void _loadReminders() {
    _remindersFuture = MaintenanceReminderService.instance.getReminders();
  }

  Future<void> _openReminderForm({Map<String, dynamic>? reminder}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderPage(reminder: reminder),
      ),
    );
    if (!mounted) return;
    setState(_loadReminders);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenance_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _remindersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Не удалось загрузить напоминания'),
                    TextButton(
                      onPressed: () => setState(_loadReminders),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }

            final reminders = snapshot.data ?? [];
            if (reminders.isEmpty) {
              return const Center(
                child: Text('Пока нет напоминаний о техобслуживании'),
              );
            }

            return ListView.separated(
              itemCount: reminders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return ReminderCard(
                  reminder: reminder,
                  onTap: () => _openReminderForm(reminder: reminder),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_maintenance_button',
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        onPressed: () => _openReminderForm(),
        child: const Icon(Icons.add, size: 31),
      ),
    );
  }
}
