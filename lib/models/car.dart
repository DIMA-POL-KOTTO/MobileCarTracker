import 'package:car_tracker/models/fuel_type.dart';

class Car {
  final int? id; 
  final String name;
  final FuelType fuelType;
  final int mileage;

  Car({
    this.id,
    required this.name,
    required this.fuelType,
    required this.mileage,
  });

  Map<String, dynamic> toDB() {
    return {
      'name': name,
      'fuelType': fuelType.name,
      'mileage': mileage,
    };
  }

  factory Car.fromDB(Map<String, dynamic> data) {
    return Car(id: data['id'] as int,
      name: data['name'] as String,
      fuelType: FuelType.values.firstWhere((type) => type.name == data['fuelType']),
      mileage: data['mileage'] as int);
  }

  Car copyWith({
    int? id,
    String? name,
    FuelType? fuelType,
    int? mileage,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
    );
  }
}