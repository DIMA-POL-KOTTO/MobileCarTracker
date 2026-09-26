import 'package:car_tracker/services/scan_manager.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/fuel_type.dart';
import 'package:car_tracker/services/models/parsed_receipt.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/services/image_picker.dart';
import 'package:car_tracker/models/fuel_entry.dart';
import 'package:car_tracker/services/fuel_manager.dart';
import 'package:car_tracker/utils.dart';

class FuelForm extends StatefulWidget {
  final ParsedReceipt? initialData;
  final bool isEditing;
  final ReceiptScan? scan;
  const FuelForm({super.key, this.initialData, this.isEditing = false, this.scan});

  @override
  State<FuelForm> createState() => _FuelFormState();
}
class _FuelFormState extends State<FuelForm> {
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  DateTime? _selectedDate;
  FuelType? _fuelType;

  @override
  void initState() {
    super.initState();
    final data = widget.initialData;
    if (data != null) {
      _stationController.text = data.station ?? '';
      _organizationController.text = data.organization ?? '';
      _amountController.text = data.amount?.toString() ?? '';
      _priceController.text = data.price?.toString() ?? '';
      _totalCostController.text = data.totalCost?.toString() ?? '';
      _fuelType = data.fuelType;
      if (data.date != null) {
        _selectedDate = data.date;
        _dateController.text = '${data.date!.day.toString().padLeft(2, '0')}.${data.date!.month.toString().padLeft(2, '0')}.${data.date!.year}';
      }
    }
  }

  @override
  void dispose() {
    _stationController.dispose();
    _organizationController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    _totalCostController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fuel_form),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _organizationController,
              decoration: InputDecoration(
                labelText: "Организация",
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _stationController,
              decoration: InputDecoration(
                labelText: l10n.fuel_station,
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: l10n.fuel_date,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                    _dateController.text = '${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year}';
                  });
                }
              }
            ),
            SizedBox(height: 16,),
            DropdownButtonFormField<FuelType>(
              initialValue: _fuelType,
              decoration: InputDecoration(labelText: l10n.fuel_type),
              items: FuelType.values.map((type) {
                return DropdownMenuItem<FuelType>(
                  value: type,
                  child: Text(fuelTypeName(type)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _fuelType = value;
                });
              },
            ),
           
            SizedBox(height: 16,),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.fuel_amount,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.fuel_price,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _totalCostController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                labelText: l10n.fuel_total_cost,
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),

            _buildTotalCostWarning(),

            const SizedBox(height: 16),

            TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.fuel_mileage,
              ),
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor)),
                    child: const Text('Отмена'),
                    
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: AppTheme.backgroundColor),
                    child: Text(
                      widget.isEditing ? 'Сохранить' : 'Добавить',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      
        floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.backgroundColor,
        child: const Icon(Icons.camera_alt, size: 31,),
        onPressed: () async {
          final image = await ImagePickerService().pickImage(context);
          if (image == null) {
            return;
          }  
          if (widget.scan != null) {
            await ScanManager.instance.processScan(widget.scan!, image);
            if (!mounted) {
              return;
            }
            final result = widget.scan!.result;
            if (result != null) {
              _fillFromParsedReceipt(result);
            }
          }
        },
        
      ),
    );
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    final price = double.tryParse(_priceController.text.replaceAll(',', '.'));
    final totalCost = double.tryParse(_totalCostController.text.replaceAll(',', '.'));
    final mileage = int.tryParse(_mileageController.text);
    if (_stationController.text.trim().isEmpty || _organizationController.text.trim().isEmpty || _selectedDate == null || amount == null || price == null || totalCost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заполните обязательные поля'),
          duration:Duration(seconds: 3),
        ),
      );
      return;
    }
    final entry = FuelEntry(
      station: _stationController.text.trim(),
      organization: _organizationController.text.trim(),
      date: _selectedDate!,
      fuelType: _fuelType!,
      amount: amount,
      price: price,
      totalCost: totalCost,
      mileage: mileage,
    );
    await FuelManager.instance.add(entry);
    if (widget.scan != null) {
      ScanManager.instance.scans.remove(widget.scan);
      ScanManager.instance.notifyListeners();
    }
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }

  Widget _buildTotalCostWarning() {
    final calculated = calculatedTotalCost;
    final scanned = totalCost;
    if (calculated == null || scanned == null) {
      return const SizedBox.shrink();
    }
    final difference = (calculated - scanned).abs();
    if (difference <= 0.01) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Внимание: сумма по количеству и цене '
              '(${calculated.toStringAsFixed(2)}) '
              'не совпадает с суммой на чеке '
              '(${scanned.toStringAsFixed(2)}).',
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double? get amount {
    return double.tryParse(
      _amountController.text.replaceAll(',', '.')
    );
  }

  double? get price {
    return double.tryParse(
      _priceController.text.replaceAll(',', '.')
    );
  }

  double? get totalCost {
    return double.tryParse(
      _totalCostController.text.replaceAll(',', '.'),
    );
  }

  double? get calculatedTotalCost {
    if (amount == null || price == null) {
      return null;
    }

    return amount! * price!;
  }

  int? get mileage {
    return int.tryParse(_mileageController.text);
  }

  void _fillFromParsedReceipt(ParsedReceipt data) {
  setState(() {
    _stationController.text = data.station ?? '';

    _organizationController.text = data.organization ?? '';

    _amountController.text =
        data.amount?.toString() ?? '';

    _priceController.text =
        data.price?.toString() ?? '';

    _totalCostController.text =
        data.totalCost?.toString() ?? '';

    _fuelType = data.fuelType;

    if (data.date != null) {
      _selectedDate = data.date;

      _dateController.text =
          '${data.date!.day.toString().padLeft(2, '0')}.'
          '${data.date!.month.toString().padLeft(2, '0')}.'
          '${data.date!.year}';
    }
  });
}

}