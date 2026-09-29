import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/utils.dart';
import 'dart:io';

class CarCard extends StatelessWidget {
  final Car car;
  final AppLocalizations l10n;
  final VoidCallback? onUpdateMileage;
  final VoidCallback onDelete;

  const CarCard({super.key, required this.car, required this.l10n, this.onUpdateMileage, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: AppTheme.textColor
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
              padding: const EdgeInsetsGeometry.fromLTRB(12, 0, 12, 16),
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
            child: Column(
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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMileage(int mileage) {
    final text = mileage.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return buffer.toString();
  }
}


class _InfoBlock extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoBlock({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: AppTheme.primaryColor,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

