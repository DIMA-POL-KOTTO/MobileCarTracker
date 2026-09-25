import 'package:car_tracker/models/fuel_type.dart';

class FuelEntry {
  final String id; 
  final String station; //АЗС
  final DateTime date; //дата
  final FuelType fuelType; // тип топл
  final double amount; // кол-во в л
  final double price; //цена за литр
  final double totalCost; //итого
  final int? mileage; // пробег

  FuelEntry({
    required this.id,
    required this.station,
    required this.date,
    required this.fuelType,
    required this.amount,
    required this.price,
    required this.totalCost,
    this.mileage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station': station,
      'date': date.toIso8601String(),
      'fuelType': fuelType.name,
      'amount': amount,
      'price': price,
      'totalCost': totalCost,
      'mileage': mileage,
    };
  }

  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(id: json['id'],
      station: json['station'], 
      date: DateTime.parse(json['date']), 
      fuelType: FuelType.values.firstWhere((type) => type.name == json['fuelType']), 
      amount: (json['amount'] as num).toDouble(), 
      price: (json['price'] as num).toDouble(), 
      totalCost: (json['totalCost'] as num).toDouble(), 
      mileage: json['mileage']);
  }
}