import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';

enum MaintenanceCategory {
  oilChange(
    label: 'Замена масла',
    icon: Icons.oil_barrel_outlined,
    color: Colors.orange
  ),
  filters (
    label: 'Фильтры',
    icon: Icons.filter_alt_outlined,
    color: Colors.grey,
  ),
  inspection(
    label: 'Техосмотр',
    icon: Icons.fact_check_outlined,
    color: Colors.teal,
  ),
  other(
    label: 'Другое',
    icon: Icons.build_outlined,
    color: AppTheme.primaryColor,
  );
  final String label;
  final IconData icon;
  final Color color;
  const MaintenanceCategory ({required this.label, required this.icon, required this.color});

  static MaintenanceCategory fromLabel(String? label) {
    return MaintenanceCategory.values.firstWhere(
      (category) => category.label == label,
      orElse: () => MaintenanceCategory.other,
    );
  }
}