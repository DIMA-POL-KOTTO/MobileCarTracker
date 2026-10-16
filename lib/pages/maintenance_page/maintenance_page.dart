import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/pages/maintenance_page/add_reminder_page.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/services/maintenance_service.dart';
import 'package:car_tracker/widgets/history_maintenance_card.dart';
import 'package:car_tracker/widgets/reminder_card.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  final CarManager _carManager = CarManager.instance;
  final Set<int> _selectedHistoryIds = {};
  bool _isHistorySelectionMode = false;
  late Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)>
  _dataFuture;

  @override
  void initState() {
    super.initState();
    _carManager.addListener(_onCarManagerChanged);
    _loadMaintenanceData();
  }

  void _onCarManagerChanged() {
    if (mounted) setState(() {});
  }

  void _loadMaintenanceData() {
    _dataFuture = _fetchMaintenanceData();
  }

  Future<(List<Map<String, dynamic>>, List<Map<String, dynamic>>)>
  _fetchMaintenanceData() async {
    await _carManager.init();
    final service = MaintenanceReminderService.instance;
    final remindersFuture = service.getReminders();
    final historyFuture = service.getMaintenanceHistory();
    return (await remindersFuture, await historyFuture);
  }

  Color _urgencyColor(Map<String, dynamic> reminder) {
    if (reminder['reminderType'] == 'mileage') {
      final dueMileage = int.tryParse(reminder['dueM']?.toString() ?? '');
      final currentMileage = _carManager.cars.isEmpty
          ? null
          : _carManager.cars.first.mileage;
      if (dueMileage == null || currentMileage == null) return Colors.green;
      if (currentMileage >= dueMileage) return Colors.red;
      if (dueMileage - currentMileage <= 1000) return Colors.amber;
      return Colors.green;
    }

    final dueDate = _parseReminderDate(reminder['dueD']?.toString());
    if (dueDate == null) return Colors.green;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (dueDate.isBefore(today)) return Colors.red;
    if (!dueDate.isAfter(_addCalendarMonth(today))) return Colors.amber;
    return Colors.green;
  }

  DateTime? _parseReminderDate(String? value) {
    if (value == null) return null;
    final parts = value.split('.');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  DateTime _addCalendarMonth(DateTime date) {
    final monthIndex = date.month;
    final year = date.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(year, month, day);
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
  void dispose() {
    _carManager.removeListener(_onCarManagerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isHistorySelectionMode
              ? 'Выбрано: ${_selectedHistoryIds.length}'
              : l10n.maintenance_page,
        ),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          if (_isHistorySelectionMode)
            IconButton(
              onPressed: _selectedHistoryIds.isEmpty
                  ? null
                  : _confirmDeleteHistory,
              icon: const Icon(Icons.delete),
            ),
        ],
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
                            urgencyColor: _urgencyColor(reminder),
                            onTap: () => _openReminderForm(reminder: reminder),
                          ),
                        ),
                      ),
                    ],
                    if (history.isNotEmpty) ...[
                      AppSectionHeading(title: 'История'),
                      ...history.map(_buildHistoryCard),
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

  Widget _buildHistoryCard(Map<String, dynamic> entry) {
    final id = entry['id'];
    final isSelected = id is int && _selectedHistoryIds.contains(id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: HistoryMaintenanceCard(
        history: entry,
        leading: _isHistorySelectionMode && id is int
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => _toggleHistorySelection(id),
              )
            : null,
        onLongPress: id is int ? () => _startHistorySelection(id) : null,
        onTap: _isHistorySelectionMode && id is int
            ? () => _toggleHistorySelection(id)
            : null,
      ),
    );
  }

  void _startHistorySelection(int id) {
    setState(() {
      _isHistorySelectionMode = true;
      _selectedHistoryIds.add(id);
    });
  }

  void _toggleHistorySelection(int id) {
    setState(() {
      if (_selectedHistoryIds.contains(id)) {
        _selectedHistoryIds.remove(id);
      } else {
        _selectedHistoryIds.add(id);
      }
      if (_selectedHistoryIds.isEmpty) {
        _isHistorySelectionMode = false;
      }
    });
  }

  Future<void> _confirmDeleteHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить записи ТО?'),
        content: Text('Выбрано ${_selectedHistoryIds.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await MaintenanceReminderService.instance.deleteHistoryEntries(
      _selectedHistoryIds,
    );
    if (!mounted) return;
    setState(() {
      _selectedHistoryIds.clear();
      _isHistorySelectionMode = false;
      _loadMaintenanceData();
    });
  }
}
