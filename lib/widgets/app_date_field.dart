import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/utils.dart';

class AppDateField extends StatelessWidget{
  final DateTime? date;
  final VoidCallback onTap;
  final String placeholder;

  const AppDateField({super.key, required this.date, required this.onTap, this.placeholder = 'Выберите дату'});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: AppTheme.secondaryColor,
          ),
          suffixIcon: const Icon(Icons.calendar_month_outlined),
          filled: true,
          fillColor: AppTheme.primaryColor.withValues(alpha: 0.04),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppTheme.primaryColor,
              width: 1.5,
            ),
          ),
        ),
        child: Text(
          date == null ? placeholder : formatDate(date!),
          style: TextStyle(
            color: date == null ? AppTheme.secondaryColor : AppTheme.textColor,
            fontSize: 14,
            height: 1.7,
          ),
        ),
      ),
    );
  }

}

