import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';
import 'package:car_tracker/services/maintenance_service.dart';
import 'package:car_tracker/widgets/history_maintenance_card.dart';
import 'package:car_tracker/widgets/reminder_card.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  late Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)>
  _dataFuture;

  @override
  void initState() {
    super.initState();
    _loadMaintenanceData();
  }

  void _loadMaintenanceData() {
    _dataFuture = _fetchMaintenanceData();
  }

  Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)>
  _fetchMaintenanceData() async {
    final service = MaintenanceReminderService.instance;
    final remindersFuture = service.getReminders();
    final historyFuture = service.getMaintenanceHistory();
    return (await remindersFuture, await historyFuture);
  }

  Future<void> _openReminderForm({Map<String, dynamic>? reminder}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderPage(reminder: reminder),
      ),
    );
    if (!mounted) return;
    setState(_loadMaintenanceData);
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
        child:
            FutureBuilder<
              (List<Map<String, dynamic>>, List<Map<String, dynamic>>)
            >(
              future: _dataFuture,
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
                          onPressed: () => setState(_loadMaintenanceData),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }

                final data = snapshot.data;
                if (data == null || (data.$1.isEmpty && data.$2.isEmpty)) {
                  return const Center(
                    child: Text('Пока нет напоминаний о техобслуживании'),
                  );
                }

                final reminders = data.$1;
                final history = data.$2;
                return ListView(
                  children: [
                    if (reminders.isNotEmpty) ...[
                      AppSectionHeading(title: 'Напоминания'),
                      ...reminders.map(
                        (reminder) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ReminderCard(
                            reminder: reminder,
                            onTap: () => _openReminderForm(reminder: reminder),
                          ),
                        ),
                      ),
                    ],
                    if (history.isNotEmpty) ...[
                      AppSectionHeading(title: 'История'),
                      ...history.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: HistoryMaintenanceCard(history: entry),
                        ),
                      ),
                    ],
                  ],
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
