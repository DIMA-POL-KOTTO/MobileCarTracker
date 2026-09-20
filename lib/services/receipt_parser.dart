import 'package:car_tracker/models/fuel_type.dart';
import 'package:car_tracker/services/models/parsed_receipt.dart';

class ReceiptParser {
  static ParsedReceipt parse(String text) {
    return ParsedReceipt(
      station: _parseStation(text),
      date: _parseDate(text),
      fuelType: _parseFuelType(text),
      amount: _parseAmount(text),
      price: _parsePrice(text),
      totalCost: _parseTotalCost(text),
    );
  }
  //АЗС
  static String? _parseStation(String text) {
    final lines = text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    String? organization;
    String? station;
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('Белоруснефть')) {
        organization = line;
        if (i + 1 < lines.length && lines[i + 1].contains('Гроднооблнефтепродукт')) {
          organization = '$organization${lines[i + 1]}';
        }
      }  
      if (line.contains('МАЗС')) {
        station = line; 
      }
    }
    
    if (organization == null && station == null) {
      return null;
    }
    if (organization != null && station != null) {
      return '$organization, $station';
    }
    return organization ?? station;
  }
  
  //Дата
  static DateTime? _parseDate(String text) {
    final regex = RegExp(r'(\d{2})\.(\d{2})\.(\d{4})');
    final match = regex.firstMatch(text);
    if (match == null) {
      return null;
    }
    final day = int.parse(match.group(1)!);
    final month = int.parse(match.group(2)!);
    final year = int.parse(match.group(3)!);
    return DateTime(year, month, day);
  }

    //Тип топлива
  static FuelType? _parseFuelType(String text) {
    if (text.contains('ДТ-')) {
      return FuelType.diesel;
    }
    if (text.contains('АИ-92')) {
      return FuelType.petrol92;
    }
    if (text.contains('АИ-95')) {
      return FuelType.petrol95;
    }
    if (text.contains('АИ-98')) {
      return FuelType.petrol98;
    }
    if (text.contains('АИ-100')) {
      return FuelType.petrol100;
    }
    return null;
  }

  //Кол-во топлива
  static double? _parseAmount(String text) {
    final regex = RegExp(
      r'(\d+[.,]\d+)\s*л\s*\*',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match == null) {
      return null;
    }
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }

  //Цена за литр
  static double? _parsePrice(String text) {
    final regex = RegExp(
      r'\d+[.,]\d+\s*л\s*\*\s*(\d+[.,]\d+)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match == null){
      return null;
    }
    return double.tryParse(match.group(1)!.replaceAll(',', '.'));
  }

  //Итого
  static double? _parseTotalCost(String text) {
    final regex = RegExp(
      r'=\s*(\d+[.,]\d+)\s*BYN',
      caseSensitive: false,
    );

    final match = regex.firstMatch(text);

    if (match == null) {
      return null;
    }

    return double.tryParse(
      match.group(1)!.replaceAll(',', '.'),
    );
  }
}