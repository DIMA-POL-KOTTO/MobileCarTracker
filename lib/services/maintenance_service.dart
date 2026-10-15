import 'package:car_tracker/services/db.dart';

class MaintenanceReminderService {
  MaintenanceReminderService._();
  static final MaintenanceReminderService instance =
      MaintenanceReminderService._();
      
  Future<int> insert(Map<String, dynamic> reminder) async {
    final db = await DatabaseService.instance.database;
    return db.insert(
      'maintenance_reminders',
      reminder,
    );
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
}
