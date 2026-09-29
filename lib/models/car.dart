import 'package:car_tracker/models/fuel_type.dart';

class Car {
  final int? id; 
  final String name;
  final String? imgPath;
  final FuelType fuelType;
  final int mileage;

  Car({
    this.id,
    required this.name,
    this.imgPath,
    required this.fuelType,
    required this.mileage,
  });

  Map<String, dynamic> toDB() {
    return {
      'name': name,
      'imgPath': imgPath,
      'fuelType': fuelType.name,
      'mileage': mileage
    };
  }

  factory Car.fromDB(Map<String, dynamic> data) {
    return Car(id: data['id'] as int,
      name: data['name'] as String,
      imgPath: data['imgPath'] as String?,
      fuelType: FuelType.values.firstWhere((type) => type.name == data['fuelType']),
      mileage: data['mileage'] as int);
  }

  Car copyWith({
    int? id,
    String? name,
    String? imgPath,
    FuelType? fuelType,
    int? mileage,
  }) {
    return Car(
      id: id ?? this.id,
      name: name ?? this.name,
      imgPath: imgPath ?? this.imgPath,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
    );
  }
}