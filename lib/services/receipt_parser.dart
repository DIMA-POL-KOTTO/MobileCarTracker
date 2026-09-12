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

  static String? _parseStation(String text) {
    return null;
  }

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

  static FuelType? _parseFuelType(String text) {
    return null;
  }

  static double? _parseAmount(String text) {
    return null;
  }

  static double? _parsePrice(String text) {
    return null;
  }

  static double? _parseTotalCost(String text) {
    return null;
  }
}