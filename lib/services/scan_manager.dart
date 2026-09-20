import 'package:car_tracker/config/api_keys.dart';
import 'package:car_tracker/services/google_vision.dart';
import 'package:car_tracker/services/receipt_parser.dart';
import 'package:car_tracker/services/models/parsed_receipt.dart';
import 'package:flutter/foundation.dart';

enum ScanStatus {
  processing, //обрабатывается
  ready, //завершено успешно
  needsReview, //несоответствие или пустые поля
  error //ошибка, не работает Cloud vision или нет доступа к Интернету
}

class ReceiptScan {
  final String id;
  String imagePath;
  final DateTime createdAt;
  ScanStatus status;
  ParsedReceipt? result;
  String? error;
  ReceiptScan({
    required this.id,
    required this.imagePath,
    required this.createdAt,
    required this.status,
    this.result,
    this.error
  });
}

class ScanManager extends ChangeNotifier{
  ScanManager._(); // один менеджер на всё приложение
  static final ScanManager instance = ScanManager._();
  final List<ReceiptScan> scans = [];
  final GoogleVisionService _vision = GoogleVisionService(apiKey: ApiKeys.googleVision);
  Future<ParsedReceipt> recognizeReceipt (String imagePath) async {
    final text = await _vision.recognizeText(imagePath);
    return ReceiptParser.parse(text);
  } 
  Future<void> processScan(ReceiptScan scan, String imagePath) async {
    scan.status = ScanStatus.processing;
    scan.error = null;
    notifyListeners();
    try {
      scan.imagePath = imagePath;
      final parsed = await recognizeReceipt(imagePath);
      scan.result = parsed;
      if (_hasProblems(parsed)) {
        scan.status = ScanStatus.needsReview;
      }
      else {
        scan.status = ScanStatus.ready;
      }
    }
    catch (e) {
      scan.status = ScanStatus.error;
      scan.error = e.toString();
    }
    notifyListeners();
  }
  ReceiptScan createScan(String imagePath) {
    final scan = ReceiptScan(id: DateTime.now().microsecondsSinceEpoch.toString(), imagePath: imagePath, createdAt: DateTime.now(), status: ScanStatus.processing);
    scans.insert(0, scan);
    notifyListeners();
    processScan(scan, imagePath);
    return scan;
  }
  bool _hasProblems(ParsedReceipt parsed) {
    if (parsed.station == null || parsed.date == null ||
      parsed.fuelType == null ||
      parsed.amount == null ||
      parsed.price == null ||
      parsed.totalCost == null) {
      return true;
    }
    if (!parsed.station.toString().contains("АЗС №")) {
      return true;
    }
    final calculatedTotal = parsed.amount! * parsed.price!;
    final difference = (calculatedTotal - parsed.totalCost!).abs();
    return difference > 0.01;
  }
}
