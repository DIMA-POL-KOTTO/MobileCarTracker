import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/widgets/app_text_field.dart';
import 'package:car_tracker/widgets/reminder_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CompleteMaintenance extends StatefulWidget {
  final Map<String, dynamic> reminder;

  const CompleteMaintenance({super.key, required this.reminder});

  @override
  State<CompleteMaintenance> createState() => _CompleteMaintenanceState();
}

class _CompleteMaintenanceState extends State<CompleteMaintenance> {
  final _priceController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выполнение ТО'),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeading(
                title: 'Выполняемое ТО',
                subtitle: 'Проверьте выбранное напоминание',
              ),
              ReminderCard(reminder: widget.reminder),
              const SizedBox(height: 28),
              const _SectionHeading(title: 'Детали выполнения'),
              const SizedBox(height: 8),
              _FieldLabel('Цена'),
              AppTextField(
                controller: _priceController,
                hint: 'Введите стоимость',
                suffix: 'BYN',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                ],
              ),
              const SizedBox(height: 16),
              _FieldLabel('Комментарий'),
              AppTextField(
                controller: _commentController,
                hint: 'Добавьте заметку о выполненных работах',
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _SectionHeading({required this.title, this.subtitle});

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

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSecondaryColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
