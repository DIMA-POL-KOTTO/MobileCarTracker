import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/models/fuel_type.dart';
import 'package:flutter/material.dart';

class FuelForm extends StatefulWidget {
  const FuelForm({super.key});

  @override
  State<FuelForm> createState() => _FuelFormState();
}
class _FuelFormState extends State<FuelForm> {
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  FuelType _fuelType = FuelType.diesel;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _stationController.dispose();
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
                    _dateController.text =
                        '${pickedDate.day.toString().padLeft(2, '0')}.'
                        '${pickedDate.month.toString().padLeft(2, '0')}.'
                        '${pickedDate.year}';
                  });
                }
              }
            ),
            SizedBox(height: 16,),
            TextField(
              
              decoration: InputDecoration(
                labelText: l10n.fuel_type,
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: l10n.fuel_amount,
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: l10n.fuel_price,
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _totalCostController,
              decoration: InputDecoration(
                labelText: l10n.fuel_total_cost,
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: _mileageController,
              decoration: InputDecoration(
                labelText: l10n.fuel_mileage,
              ),
            ),
          ],
        ),
      )
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

  int? get mileage {
    return int.tryParse(_mileageController.text);
  }
}