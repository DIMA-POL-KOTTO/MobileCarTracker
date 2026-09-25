import 'dart:convert';
import 'package:car_tracker/models/fuel_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelManager extends ChangeNotifier {
  FuelManager._();
  static final FuelManager instance = FuelManager._();
  static const String _storageKey = 'fuel_entries';
  final List<FuelEntry> entries = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    final prefs = await SharedPreferences.getInstance();
    final savedEntries = prefs.getStringList(_storageKey);
    if (savedEntries == null) {
      return;
    }
    entries.clear();
    for (final item in savedEntries) {
      try {
        final json = jsonDecode(item) as Map<String, dynamic>;
        entries.add(FuelEntry.fromJson(json));
      } catch (e) {
        debugPrint('Ошибка загрузки заправки: $e');
      }
    }
    notifyListeners();
  }

  Future<void> add(FuelEntry entry) async {
    entries.insert(0, entry);
    await _saveToStorage();
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final data = entries
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, data);
  }

  Future<void> deleteEntries(Set <String> ids) async {
    entries.removeWhere((entry) => ids.contains(entry.id));
    await _saveToStorage();
    notifyListeners();
  }
}