import 'package:car_tracker/services/db.dart';

class MaintenanceReminderService {
  MaintenanceReminderService._();
  static final MaintenanceReminderService instance =
      MaintenanceReminderService._();

  Future<int> insert(Map<String, dynamic> reminder) async {
    final db = await DatabaseService.instance.database;
    return db.insert('maintenance_reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('maintenance_reminders', orderBy: 'id DESC');
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Future<List<Map<String, dynamic>>> getMaintenanceHistory() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query('maintenance_history', orderBy: 'id DESC');
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
  }

  Future<void> deleteHistoryEntries(Set<int> ids) async {
    if (ids.isEmpty) return;

    final db = await DatabaseService.instance.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      'maintenance_history',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
    );
  }

  Future<void> update(Map<String, dynamic> reminder) async {
    final id = reminder['id'];
    if (id is! int) {
      throw ArgumentError('Reminder must have an integer id');
    }

    final values = Map<String, dynamic>.from(reminder)..remove('id');
    final db = await DatabaseService.instance.database;
    await db.update(
      'maintenance_reminders',
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> completeReminder(Map<String, dynamic> historyEntry) async {
    final reminderId = historyEntry['reminderId'];
    if (reminderId is! int) {
      throw ArgumentError('History entry must have an integer reminderId');
    }

    final db = await DatabaseService.instance.database;
    await db.transaction((transaction) async {
      await transaction.insert('maintenance_history', historyEntry);
      final deleted = await transaction.delete(
        'maintenance_reminders',
        where: 'id = ?',
        whereArgs: [reminderId],
      );
      if (deleted == 0) {
        throw StateError('Reminder $reminderId does not exist');
      }
    });
  }
}
