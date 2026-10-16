import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/models/fuel_entry.dart';
import 'package:car_tracker/utils.dart';

class FuelCard extends StatelessWidget {
  final FuelEntry entry;
  final Widget? leading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const FuelCard({
    super.key,
    required this.entry,
    this.leading,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: leading,
        title: Row(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(
              entry.station,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.only(left: 8),
              child: Text(entry.organization,
                style: const TextStyle(
                  fontSize: 12, color: AppTheme.secondaryColor),
                ),
              )
          ]
        ),
        subtitle: Text(
          '${formatDate(entry.date)}\n'
          '${fuelTypeName(entry.fuelType)} · '
          '${entry.amount.toStringAsFixed(2)} л · '
          '${entry.totalCost.toStringAsFixed(2)} BYN',
        ),
        isThreeLine: true,
        onLongPress: onLongPress,
        onTap: onTap,
      ),
    );
  }
}