import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

Future<String> preprocessImage(String inputPath) async {
  // 1. Читаем исходное изображение
  final bytes = await File(inputPath).readAsBytes();
  img.Image image = img.decodeImage(bytes)!;

  // 2. Уменьшаем до 2000px по ширине (Tesseract любит этот диапазон)
  if (image.width > 2000) {
    image = img.copyResize(image, width: 2000);
  }

  // 3. Переводим в градации серого — убирает шум от цвета
  image = img.grayscale(image);

  // 4. Повышаем контраст — делает текст жирнее
  image = img.adjustColor(image, contrast: 1.2);

  // 5. Бинаризация — оставляет только чёрное и белое
  //    threshold: 0.6 — можно экспериментировать (0.4 ... 0.7)
  image = img.luminanceThreshold(image, threshold: 0.6);

  // 6. Сохраняем во временную папку
  final tempDir = await getTemporaryDirectory();
  final outputPath =
      '${tempDir.path}/preprocessed_${DateTime.now().millisecondsSinceEpoch}.png';
  await File(outputPath).writeAsBytes(img.encodePng(image));
  return outputPath;
}