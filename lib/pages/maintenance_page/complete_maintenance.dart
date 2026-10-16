import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/services/maintenance_service.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/utils.dart';
import 'package:car_tracker/widgets/app_section_heading.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _mileageController = TextEditingController();
  final _commentController = TextEditingController();
  int? _carId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentMileage();
  }

  Future<void> _loadCurrentMileage() async {
    final carManager = CarManager.instance;
    await carManager.init();
    if (!mounted) return;

    if (carManager.cars.isNotEmpty) {
      final car = carManager.cars.first;
      _carId = car.id;
      _mileageController.text = car.mileage.toString();
      setState(() {});
    }
  }

  Future<void> _completeMaintenance() async {
    if (_saving || !_formKey.currentState!.validate()) return;

    final reminderId = widget.reminder['id'];
    final carId = _carId ?? widget.reminder['carId'];
    if (reminderId is! int || carId is! int) {
      _showMessage('Не удалось определить автомобиль или напоминание');
      return;
    }

    final priceText = _priceController.text.trim().replaceAll(',', '.');
    final cost = priceText.isEmpty ? null : double.tryParse(priceText);
    setState(() => _saving = true);

    try {
      await MaintenanceReminderService.instance.completeReminder({
        'carId': carId,
        'reminderId': reminderId,
        'title': widget.reminder['title'],
        'category': widget.reminder['category'],
        'date': formatDate(DateTime.now()),
        'mileage': int.parse(_mileageController.text),
        'cost': cost,
        'comment': _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _showMessage('Не удалось сохранить выполненное ТО');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _priceController.dispose();
    _mileageController.dispose();
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionHeading(
                  title: 'Выполняемое ТО',
                  subtitle: 'Проверьте выбранное напоминание',
                ),
                ReminderCard(reminder: widget.reminder),
                const SizedBox(height: 28),
                const AppSectionHeading(title: 'Детали выполнения'),
                const SizedBox(height: 8),
                const _FieldLabel('Пробег'),
                AppTextField(
                  controller: _mileageController,
                  hint: 'Введите пробег',
                  suffix: 'км',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    final mileage = int.tryParse(value ?? '');
                    if (mileage == null || mileage < 0) {
                      return 'Введите корректный пробег';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Цена'),
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
                  validator: (value) {
                    final text = value?.trim().replaceAll(',', '.') ?? '';
                    if (text.isNotEmpty && double.tryParse(text) == null) {
                      return 'Введите корректную стоимость';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const _FieldLabel('Комментарий'),
                AppTextField(
                  controller: _commentController,
                  hint: 'Добавьте заметку о выполненных работах',
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _completeMaintenance,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.backgroundColor,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_saving ? 'Сохраняем…' : 'Выполнить ТО'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: AppTheme.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
