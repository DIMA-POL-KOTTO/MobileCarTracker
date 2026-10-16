import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/maintenance_category.dart';

class ReminderCard extends StatelessWidget {
  final Map<String, dynamic> reminder;
  final VoidCallback? onTap;
  final Color? urgencyColor;

  const ReminderCard({
    super.key,
    required this.reminder,
    this.onTap,
    this.urgencyColor,
  });

  @override
  Widget build(BuildContext context) {
    final title = reminder['title']?.toString() ?? 'Техобслуживание';
    final category = reminder['category']?.toString();
    final maintenanceCategory = MaintenanceCategory.fromLabel(category);
    final isMileageReminder = reminder['reminderType'] == 'mileage';
    final dueMileage = reminder['dueM'];
    final dueDate = reminder['dueD']?.toString();
    final hasDueMileage = dueMileage != null;
    final hasDueDate = dueDate != null && dueDate.isNotEmpty;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.12)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  if (urgencyColor != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: urgencyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
              if ((isMileageReminder && hasDueMileage) ||
                  (!isMileageReminder && hasDueDate)) ...[
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      isMileageReminder ? Icons.speed : Icons.calendar_today,
                      size: 18,
                      color: AppTheme.secondaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isMileageReminder
                            ? 'Следующее ТО: $dueMileage км'
                            : 'Следующее ТО: $dueDate',
                        style: const TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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
}
