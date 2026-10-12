import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';

class AddReminderPage extends StatelessWidget{
  const AddReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новое напоминание'),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor, fontSize: 24, fontWeight: FontWeight.bold,
        ),
      ),
      body: const Center(
        child: Text("Экран добавления напоминания")
      ),
    );
  }
}