import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final AppLocalizations l10n;

  const CarCard({super.key, required this.car, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(l10n.current_mileage),

            const SizedBox(height: 5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${car.mileage} ${l10n.km}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  child: Text(l10n.update_btn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

