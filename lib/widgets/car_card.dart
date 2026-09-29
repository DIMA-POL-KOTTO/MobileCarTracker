import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/utils.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final AppLocalizations l10n;
  final VoidCallback? onUpdateMileage;

  const CarCard({super.key, required this.car, required this.l10n, this.onUpdateMileage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Название автомобиля
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.directions_car,
                    size: 28,
                    color: AppTheme.primaryColor,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Пробег + топливо
            Row(
              children: [

                // Пробег
                Expanded(
                  child: _InfoBlock(
                    icon: Icons.speed,
                    title: l10n.current_mileage,
                    value: '${_formatMileage(car.mileage)} ${l10n.km}',
                  ),
                ),

                Container(
                  height: 70,
                  width: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),

                // Топливо
                Expanded(
                  child: _InfoBlock(
                    icon: Icons.local_gas_station,
                    title: 'Топливо',
                    value: fuelTypeName(car.fuelType),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Кнопка
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: onUpdateMileage,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Обновить пробег',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.backgroundColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
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

