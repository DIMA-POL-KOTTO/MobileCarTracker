import 'package:car_tracker/models/fuel_type.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/utils.dart';
import 'package:car_tracker/theme/app_theme.dart';

class AddCarPage extends StatefulWidget{
  const AddCarPage({super.key});

  @override
  State<AddCarPage> createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final _nameController = TextEditingController();
  final _mileageController = TextEditingController();
  FuelType? _fuelType;
  
  @override
  void dispose() {
    _nameController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить автомобиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Название автомобиля",
              ),
            ),
            const SizedBox(height: 16,),
            DropdownButtonFormField<FuelType>(
              decoration: const InputDecoration(
                labelText: 'Тип топлива',
              ),
              items: FuelType.values.map((type) {
                return DropdownMenuItem(
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
            const SizedBox(height: 16,),
            TextField(
              controller: _mileageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Текущий пробег',
                suffixText: 'км',
              ),
            ),
            SizedBox(height: 16,),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.backgroundColor,
                ),
                child: const Text('Сохранить'),
              ),
            ),
          ],
        )),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final mileage = int.tryParse(_mileageController.text);
    if (name.isEmpty || mileage == null || _fuelType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Заполните все поля"))
      );
      return;
    }

    final car = Car(name: name, fuelType: _fuelType!, mileage: mileage);
    await CarManager.instance.add(car);
    if (!mounted) {
      return;
    }
    Navigator.pop(context);
  }


}