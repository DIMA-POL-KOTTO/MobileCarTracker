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
}