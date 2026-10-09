import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/utils.dart';
import 'dart:io';

class CarCard extends StatelessWidget {
  final Car car;
  final AppLocalizations l10n;
  final Future<void> Function(int mileage) onUpdateMileage;
  final VoidCallback onDelete;

  const CarCard({super.key, required this.car, required this.l10n, required this.onUpdateMileage, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppTheme.textColor,
                    ),  
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'delete', child: Text('Удалить'),)
                  ],
                ),
              ],
            )
          ),
          if (car.imgPath != null)
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(16, 0, 16, 0),
              child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(car.imgPath!),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children:[
                Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Пробег',
                  style: TextStyle(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${car.mileage} км',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => _showMileageDialog(context),
              child: Text('Обновить',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14
                ),
               
              ),
            ),    
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMileageDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: car.mileage.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Обновить пробег'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Пробег (км)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                final int? newMileage = int.tryParse(controller.text);
                if (newMileage != null) {
                  await onUpdateMileage(newMileage);
                  Navigator.pop(context);
                } 
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
  
}

