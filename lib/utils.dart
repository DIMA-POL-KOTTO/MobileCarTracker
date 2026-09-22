import 'package:car_tracker/models/fuel_type.dart';

String fuelTypeName(FuelType type) {
  switch (type) {
    case FuelType.petrol92:
      return 'АИ-92';
    case FuelType.petrol95:
      return 'АИ-95';
    case FuelType.petrol98:
      return 'АИ-98';
    case FuelType.petrol100:
      return 'АИ-100';
    case FuelType.diesel:
      return 'Дизель';
    case FuelType.gas:
      return 'Газ';
    case FuelType.electric:
      return 'Электро';
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}