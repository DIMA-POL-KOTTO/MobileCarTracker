import 'package:car_tracker/models/maintenance_category.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HistoryMaintenanceCard extends StatelessWidget {
  final Map<String, dynamic> history;
  final Widget? leading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const HistoryMaintenanceCard({
    super.key,
    required this.history,
    this.leading,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final title = history['title']?.toString() ?? 'Техобслуживание';
    final category = history['category']?.toString();
    final completedDate = history['date']?.toString();
    final maintenanceCategory = MaintenanceCategory.fromLabel(category);
    final cost = _formatCost(history['cost']);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 8)],
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: maintenanceCategory.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      maintenanceCategory.icon,
                      color: maintenanceCategory.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (category != null && category.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if ((completedDate != null && completedDate.isNotEmpty) ||
                  cost != null) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (completedDate != null && completedDate.isNotEmpty) ...[
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppTheme.secondaryColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          completedDate,
                          style: const TextStyle(
                            color: AppTheme.textSecondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ] else
                      const Spacer(),
                    if (cost != null)
                      Text(
                        '$cost BYN',
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _formatCost(dynamic value) {
    if (value == null) return null;
    final amount = value is num ? value.toDouble() : double.tryParse('$value');
    if (amount == null) return null;
    return amount == amount.roundToDouble()
        ? amount.toStringAsFixed(0)
        : amount.toStringAsFixed(2);
  }
}
