import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GoogleVisionService {
  final String apiKey;
  GoogleVisionService({
    required this.apiKey,
  });

  Future<String> recognizeText(String imagePath) async {
    final imageBytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=$apiKey', );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'requests': [{'image': {'content': base64Image,},'features':[{'type': 'DOCUMENT_TEXT_DETECTION',},],'imageContext': {'languageHints': ['ru'],},},],}),
    );
    //а вдруг ошибка
    if (response.statusCode != 200) {
      throw Exception(
        'Google Vision ошибка: '
        '${response.statusCode}\n${response.body}',
      );
    }
    final data = jsonDecode(response.body);
    final annotation = data['responses'][0]['fullTextAnnotation'];
    if (annotation == null) {
      return '';
    }
    return annotation['text'] ?? '';
  }
}