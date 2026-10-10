import 'package:car_tracker/models/fuel_type.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

String fuelTypeCarName(FuelTypeCar type) {
  switch (type) {
    case FuelTypeCar.petrol:
      return 'Бензин';
    case FuelTypeCar.diesel:
      return 'Дизель';
    case FuelTypeCar.gas:
      return 'Газ';
    case FuelTypeCar.electric:
      return 'Электро';
  }
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}.'
      '${date.month.toString().padLeft(2, '0')}.'
      '${date.year}';
}

String monthName(DateTime date) {
  const months = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь',
  ];
  if (date.month < 1 || date.month > 12) {
    return '';
  }
  return '${months[date.month - 1]} ${date.year}';
}