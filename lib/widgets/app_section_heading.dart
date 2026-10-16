import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppSectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppSectionHeading({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                color: AppTheme.secondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }
}