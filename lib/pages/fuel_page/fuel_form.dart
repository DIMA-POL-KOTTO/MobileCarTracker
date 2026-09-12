import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class FuelForm extends StatefulWidget {
  const FuelForm({super.key});

  @override
  State<FuelForm> createState() => _FuelFormState();
}
class _FuelFormState extends State<FuelForm> {
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _totalCostController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  
  @override
  void dispose() {
    _stationController.dispose();
    _dateController.dispose();
    _fuelTypeController.dispose();
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
            
          ],
        ),
      )
    );
  }
}