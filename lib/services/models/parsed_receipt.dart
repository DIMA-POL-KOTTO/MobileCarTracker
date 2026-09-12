import 'package:car_tracker/models/fuel_type.dart';

class ParsedReceipt {
  final String? station;
  final DateTime? date;
  final FuelType? fuelType;
  final double? amount;
  final double? price;
  final double? totalCost;

  ParsedReceipt({
    this.station,
    this.date,
    this.fuelType,
    this.amount,
    this.price,
    this.totalCost,
  });
}