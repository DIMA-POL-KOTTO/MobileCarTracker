import 'package:car_tracker/models/fuel_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:car_tracker/services/db.dart';

class FuelManager extends ChangeNotifier {
  FuelManager._();
  static final FuelManager instance = FuelManager._();
  final List<FuelEntry> entries = [];
  bool _initialized = false;

  Future<void> init() async {
    if(_initialized) {
      return;
    }
    _initialized = true;
    final db = await DatabaseService.instance.database;
    final data = await db.query('fuel_entries',
      orderBy: 'date DESC, id DESC',
    );
    entries.clear();
    for (final row in data) {
      entries.add(FuelEntry.fromDB(row));
    }
    notifyListeners();
  }

  Future<void> add(FuelEntry entry) async {
    final db = await DatabaseService.instance.database;
    final id = await db.insert("fuel_entries", entry.toDB());
    final savedEntry = entry.copyWith(id: id);
    entries.insert(0, savedEntry);
    notifyListeners();
  }

  Future<void> deleteEntries(Set<int> ids) async {
    if (ids.isEmpty) {
      return;
    }
    final db = await DatabaseService.instance.database;
    final placeholders = List.filled(ids.length, '?').join(',');
    await db.delete(
      'fuel_entries',
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
    );
    entries.removeWhere(
      (entry) => entry.id != null && ids.contains(entry.id),
    );
    notifyListeners();
  }
}