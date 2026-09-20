import 'package:car_tracker/models/fuel_type.dart';

class FuelEntry {
  final String station; //АЗС
  final DateTime date; //дата
  final FuelType fuelType; // тип топл
  final double amount; // кол-во в л
  final double price; //цена за литр
  final double totalCost; //итого
  final int? mileage; // пробег

  FuelEntry({
    required this.station,
    required this.date,
    required this.fuelType,
    required this.amount,
    required this.price,
    required this.totalCost,
    this.mileage,
  });
}