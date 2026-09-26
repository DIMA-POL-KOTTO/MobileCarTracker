import 'package:car_tracker/models/fuel_type.dart';

class FuelEntry {
  final int? id; 
  final String station; //АЗС
  final String organization;
  final DateTime date; //дата
  final FuelType fuelType; // тип топл
  final double amount; // кол-во в л
  final double price; //цена за литр
  final double totalCost; //итого
  final int? mileage; // пробег

  FuelEntry({
    this.id,
    required this.station,
    required this.organization,
    required this.date,
    required this.fuelType,
    required this.amount,
    required this.price,
    required this.totalCost,
    this.mileage,
  });

  Map<String, dynamic> toDB() {
    return {
      'station': station,
      'organization': organization,
      'date': date.toIso8601String(),
      'fuelType': fuelType.name,
      'amount': amount,
      'price': price,
      'totalCost': totalCost,
      'mileage': mileage,
    };
  }

  factory FuelEntry.fromDB(Map<String, dynamic> data) {
    return FuelEntry(id: data['id'] as int,
      station: data['station'] as String,
      organization: data['organization'] as String, 
      date: DateTime.parse(data['date'] as String), 
      fuelType: FuelType.values.firstWhere((type) => type.name == data['fuelType']), 
      amount: (data['amount'] as num).toDouble(), 
      price: (data['price'] as num).toDouble(), 
      totalCost: (data['totalCost'] as num).toDouble(), 
      mileage: data['mileage'] as int?);
  }

  FuelEntry copyWith({
    int? id,
    String? station,
    String? organization,
    DateTime? date,
    FuelType? fuelType,
    double? amount,
    double? price,
    double? totalCost,
    int? mileage,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      station: station ?? this.station,
      organization: organization ?? this.organization,
      date: date ?? this.date,
      fuelType: fuelType ?? this.fuelType,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      totalCost: totalCost ?? this.totalCost,
      mileage: mileage ?? this.mileage,
    );
  }
}