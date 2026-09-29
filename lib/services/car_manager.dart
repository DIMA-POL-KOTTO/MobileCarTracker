import 'package:flutter/foundation.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/services/db.dart';

class CarManager extends ChangeNotifier {
  CarManager._();
  static final CarManager instance = CarManager._();
  final List<Car> cars = [];
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) {
      return;
    }
    _initialized = true;
    final db = await DatabaseService.instance.database;
    final data = await db.query('cars', orderBy: 'id DESC');
    cars.clear();
    for (final row in data) {
      cars.add(Car.fromDB(row));
    }
    notifyListeners();
  }

  Future<void> add(Car car) async {
    final db = await DatabaseService.instance.database;
    final id = await db.insert("cars", car.toDB());
    final savedCar = car.copyWith(id: id);
    cars.insert(0, savedCar);
    notifyListeners();
  }

  Future<void> delete(int id) async {
    final db = await DatabaseService.instance.database;
    await db.delete('cars', where: 'id = ?', whereArgs: [id]);
    cars.removeWhere((car) => car.id == id);
    notifyListeners();
  }
}