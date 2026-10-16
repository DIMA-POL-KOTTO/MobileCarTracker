import 'package:car_tracker/pages/maintenance_page/complete_maintenance.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:car_tracker/utils.dart';
import 'package:car_tracker/services/maintenance_service.dart';
import 'package:car_tracker/widgets/app_text_field.dart';
import 'package:car_tracker/widgets/app_date_field.dart';
import 'package:car_tracker/widgets/app_dropdown_field.dart';
import 'package:car_tracker/models/maintenance_category.dart';

class AddReminderPage extends StatefulWidget {
  final Map<String, dynamic>? reminder;

  const AddReminderPage({super.key, this.reminder});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final CarManager _carManager = CarManager.instance;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _currentMileageController = TextEditingController();
  final _intervalMileageController = TextEditingController();
  final _nextMileageController = TextEditingController();
  final _intervalMonthsController = TextEditingController();
  final _categories = MaintenanceCategory.values;
  MaintenanceCategory? _category = MaintenanceCategory.oilChange;
  bool _byMileage = true;
  DateTime _currentDate = DateTime.now();
  DateTime? _nextDate;
  bool _updatingNextMileage = false;
  bool _updatingNextDate = false;
  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    if (reminder != null) {
      _titleController.text = reminder['title']?.toString() ?? '';
      _category = MaintenanceCategory.fromLabel(
        reminder['category']?.toString(),
      );
      _byMileage = reminder['reminderType'] == 'mileage';
      _nextMileageController.text = reminder['dueM']?.toString() ?? '';
      _intervalMileageController.text = reminder['intervalM']?.toString() ?? '';
      _intervalMonthsController.text = reminder['intervalD']?.toString() ?? '';
      _nextDate = _parseDate(reminder['dueD']?.toString());
    }
    _currentMileageController.addListener(_recalculateMileage);
    _intervalMileageController.addListener(_recalculateMileage);
    _intervalMonthsController.addListener(_recalculateDate);
    if (reminder == null) {
      _recalculateDate();
    }
    _loadCurrentMileage();
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;
    final parts = value.split('.');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  Future<void> _loadCurrentMileage() async {
    await _carManager.init();
    if (!mounted) return;
    if (_carManager.cars.isEmpty) {
      return;
    }
    final car = _carManager.cars.first;
    _updatingNextMileage = true;
    _currentMileageController.text = car.mileage.toString();
    _updatingNextMileage = false;
    if (widget.reminder == null) {
      _recalculateMileage();
    }
  }

  void _recalculateMileage() {
    if (_updatingNextMileage) return;
    final currentMileage = int.tryParse(_currentMileageController.text);
    final interval = int.tryParse(_intervalMileageController.text);
    if (currentMileage == null ||
        interval == null ||
        currentMileage < 0 ||
        interval < 0) {
      return;
    }
    _updatingNextMileage = true;
    _nextMileageController.text = (currentMileage + interval).toString();
    _nextMileageController.selection = TextSelection.collapsed(
      offset: _nextMileageController.text.length,
    );
    _updatingNextMileage = false;
  }

  void _recalculateDate() {
    if (_updatingNextDate) return;
    final months = int.tryParse(_intervalMonthsController.text);
    if (months == null || months < 0) {
      setState(() {
        _nextDate = null;
      });
      return;
    }
    setState(() {
      _nextDate = _addMonths(_currentDate, months);
    });
  }

  DateTime _addMonths(DateTime date, int months) {
    final monthIndex = date.month - 1 + months;
    final year = date.year + monthIndex ~/ 12;
    final month = monthIndex % 12 + 1;
    final lastDay = DateTime(year, month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(year, month, day);
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    final now = DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 30),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme
                .copyWith(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
  }

  Future<void> _selectCurrentDate() async {
    final selected = await _pickDate(_currentDate);
    if (selected == null || !mounted) return;
    setState(() {
      _currentDate = selected;
      final months = int.tryParse(_intervalMonthsController.text);
      _nextDate = months != null && months > 0
          ? _addMonths(selected, months)
          : null;
    });
  }

  Future<void> _selectNextDate() async {
    final selected = await _pickDate(_nextDate ?? _currentDate);
    if (selected == null || !mounted) return;
    setState(() {
      _nextDate = selected;
      _updatingNextDate = true;
      _intervalMonthsController.clear();
      _updatingNextDate = false;
    });
  }

  Future<void> _saveReminder() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_byMileage && _nextDate == null) {
      _showMessage('Выберите дату следующего ТО');
      return;
    }
    final carManager = CarManager.instance;
    await carManager.init();
    if (!mounted) return;
    if (carManager.cars.isEmpty) {
      return;
    }
    final car = carManager.cars.first;
    final existingReminder = widget.reminder;
    final Map<String, dynamic> reminder = {
      if (existingReminder?['id'] != null) 'id': existingReminder!['id'],
      'carId': existingReminder?['carId'] ?? car.id,
      'title': _titleController.text.trim(),
      'category': _category!.label,
      'reminderType': _byMileage ? 'mileage' : 'date',
      'dueM': _byMileage ? int.parse(_nextMileageController.text) : null,
      'dueD': !_byMileage ? formatDate(_nextDate!) : null,
      'repeatByM': existingReminder?['repeatByM'] ?? 0,
      'intervalM': _byMileage
          ? int.tryParse(_intervalMileageController.text)
          : null,
      'repeatByD': existingReminder?['repeatByD'] ?? 0,
      'intervalD': !_byMileage
          ? int.tryParse(_intervalMonthsController.text)
          : null,
    };
    try {
      if (existingReminder == null) {
        await MaintenanceReminderService.instance.insert(reminder);
      } else {
        await MaintenanceReminderService.instance.update(reminder);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Сохранено')));
      Navigator.pop(context);
    } catch (err) {
      if (!mounted) return;
      _showMessage('Ошибка сохранения');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _currentMileageController.dispose();
    _intervalMileageController.dispose();
    _nextMileageController.dispose();
    _intervalMonthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reminder == null
              ? 'Новое напоминание'
              : 'Редактирование напоминания',
        ),
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
                _buildLabel('Название ТО'),
                AppTextField(
                  controller: _titleController,
                  hint: 'Например: Замена масла',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Введите название ТО";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                _buildLabel("Категория"),
                AppDropdownField<MaintenanceCategory>(
                  value: _category,
                  hint: "Выберите категорию",
                  items: _categories.map((category) {
                    return DropdownMenuItem<MaintenanceCategory>(
                      value: category,
                      child: Text(category.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _category = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Выберите категорию';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                _buildLabel("Тип напоминания"),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _buildModeButton(
                        title: 'По пробегу',
                        selected: _byMileage,
                        onTap: () {
                          setState(() {
                            _byMileage = true;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _buildModeButton(
                        title: 'По дате',
                        selected: !_byMileage,
                        onTap: () {
                          setState(() {
                            _byMileage = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (_byMileage) ...[
                  _buildLabel('Пробег'),
                  AppTextField(
                    controller: _currentMileageController,
                    hint: "Введите текущий пробег",
                    suffix: 'км',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите текущий пробег';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildLabel("Интервал"),
                  AppTextField(
                    controller: _intervalMileageController,
                    hint: "Например: 10 000",
                    suffix: "км",
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final interval = int.tryParse(value ?? '');
                      if (interval == null || interval < 0) {
                        return 'Введите корректный интервал';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildLabel("Следующий пробег"),
                  AppTextField(
                    controller: _nextMileageController,
                    hint: "Рассчитывается автоматически",
                    suffix: "км",
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final next = int.tryParse(value ?? '');
                      final current = int.tryParse(
                        _currentMileageController.text,
                      );
                      if (next == null) {
                        return 'Введите следущий пробег';
                      }
                      if (widget.reminder == null &&
                          current != null &&
                          next < current) {
                        return "Пробег не может быть меньше текущего";
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  _buildLabel('Дата'),
                  AppDateField(date: _currentDate, onTap: _selectCurrentDate),
                  const SizedBox(height: 8),
                  _buildLabel('Интервал'),
                  AppTextField(
                    controller: _intervalMonthsController,
                    hint: "Например: 6",
                    suffix: 'мес.',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      final months = int.tryParse(value ?? '');
                      if (months == null || months < 0) {
                        return 'Введите корректный интервал';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildLabel('Следующая дата'),
                  AppDateField(
                    date: _nextDate,
                    placeholder: "Рассчитывается автоматически",
                    onTap: _selectNextDate,
                  ),
                ],
                const SizedBox(height: 16),
                widget.reminder != null
                    ? SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () async {
                            final completed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompleteMaintenance(
                                  reminder: widget.reminder!,
                                ),
                              ),
                            );
                            if (completed != true || !context.mounted) return;
                            Navigator.pop(context, true);
                          },

                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Выполнить ТО",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 0),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.reminder == null
                          ? 'Сохранить напоминание'
                          : 'Изменить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: AppTheme.textColor, fontSize: 15),
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(microseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primaryColor : AppTheme.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? AppTheme.backgroundColor : AppTheme.textColor,
            ),
          ),
        ),
      ),
    );
  }
}
