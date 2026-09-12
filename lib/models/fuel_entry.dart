import 'package:car_tracker/models/fuel_type.dart';

class FuelEntry {
  final String station;
  final DateTime date;
  final FuelType fuelType;
  final double amount;
  final double price;
  final double totalCost;
  final int? mileage;

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