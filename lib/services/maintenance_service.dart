import 'package:car_tracker/services/db.dart';

class MaintenanceReminderService {
  MaintenanceReminderService._();
  static final MaintenanceReminderService instance =
      MaintenanceReminderService._();

  Future<int> insert(Map<String, dynamic> reminder) async {
    final db = await DatabaseService.instance.database;
    return db.insert('maintenance_reminders', reminder);
  }

  Future<List<Map<String, dynamic>>> getActiveReminders() async {
    final db = await DatabaseService.instance.database;
    final rows = await db.query(
      'maintenance_reminders',
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'id DESC',
    );
    return rows.map((row) => Map<String, dynamic>.from(row)).toList();
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
}
