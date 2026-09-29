import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EmptyCarCard extends StatelessWidget {
  final VoidCallback onAdd;

  const EmptyCarCard({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.directions_car,
              size: 64,
              color: AppTheme.primaryColor,
            ),

            const SizedBox(height: 16),

            const Text(
              'Автомобиль не добавлен',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Добавьте автомобиль, чтобы начать отслеживать его состояние и заправки.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Добавить автомобиль'),
            ),
          ],
        ),
      ),
    );
  }
}