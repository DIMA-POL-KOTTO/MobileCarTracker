import 'package:car_tracker/pages/fuel_page/fuel_form.dart';
import 'package:car_tracker/services/google_vision.dart';
import 'package:car_tracker/services/receipt_parser.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:car_tracker/config/api_keys.dart';
import 'package:flutter/material.dart';

class AddFuelPage extends StatelessWidget {
  const AddFuelPage({super.key});

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Галерея'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        
        title: Text(l10n.add_fuel_page),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 90,
                child: ElevatedButton(
                  onPressed: () async {
                    final source = await _showImageSourceDialog(context);
                    if (source == null) {
                      return;
                    }
                    final picker = ImagePicker();

                    final image = await picker.pickImage(source: source);
                    if (image == null) {
                      return;
                    }
                    print('Фото чека: ${image.path}');

                    try {
                      final vision = GoogleVisionService(apiKey: ApiKeys.googleVision,);
                      final text = await vision.recognizeText(image.path);
                      print('========== GOOGLE VISION ==========');
                      print(text);
                      print('===================================');
                      final parsed = ReceiptParser.parse(text);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuelForm(
                            initialData: parsed,
                          ),
                        ),
                      );
                    } catch (e) {
                      print('ОШИБКА Google Vision');
                    }
                    
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt, size: 32, color: AppTheme.primaryColor),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.fuel_page_photo_btn_h,
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textColor,
                          ),
                          ),
                          const SizedBox(height: 4),
                          Text(l10n.fuel_page_photo_btn_p,
                            style: TextStyle(fontSize: 13, color: AppTheme.textSecondaryColor
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            SizedBox(
              width: double.infinity,
              height: 90,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FuelForm(),
                    ),
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 32, color: AppTheme.primaryColor),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.fuel_page_manual_btn_h,
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textColor
                        ),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.fuel_page_manual_btn_p, 
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondaryColor
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}