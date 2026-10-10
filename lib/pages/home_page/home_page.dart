import 'package:car_tracker/pages/fuel_page/fuel_form.dart';
import 'package:car_tracker/pages/home_page/add_car_page.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/widgets/car_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/widgets/car_card.dart';
import 'package:car_tracker/widgets/fuel_card.dart';
import 'package:car_tracker/services/fuel_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarManager _carManager = CarManager.instance;
  final FuelManager _fuelManager = FuelManager.instance;

  @override
  void initState() {
    super.initState();
    _carManager.addListener(_onCarChanged);
    _carManager.init();
    _fuelManager.addListener(_onFuelChanged);
    _fuelManager.init();
  }

  @override
  void dispose() {
    _carManager.removeListener(_onCarChanged);
    _fuelManager.removeListener(_onFuelChanged);
    super.dispose();
  }

  void _onCarChanged() {
    setState(() {});
  }

  void _onFuelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildContent(l10n)
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final List<Widget> children = [];
    if (_carManager.cars.isEmpty) {
      return EmptyCarCard(onAdd: _addCar);
    }
    else {
      Car car = _carManager.cars.first;
      children.add(CarCard(car: car, l10n: l10n, onDelete: () async {
        if (car.id == null) {
          return;
        }
        await _carManager.delete(car.id!);
      }, onUpdateMileage: (mileage) async {
        if (car.id == null) {
          return;
        }
        await _carManager.updateMileage(car.id!, mileage);
      },
      ),
      );
    }
    children.addAll([
      const SizedBox(height: 16,),
      const Padding(
      padding: EdgeInsets.fromLTRB(8,0,0,0),
      child:  Text (
        'Последняя заправка', 
        style: TextStyle(color: AppTheme.textColor, fontSize: 20, fontWeight: FontWeight.bold)
      ),),
      const SizedBox(height: 8,),
      _buildLastFuel()
    ]);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildLastFuel() {
    if (_fuelManager.entries.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Text(
              'Заправок пока нет',
              style: TextStyle(color: AppTheme.textColor),
            ),
          ),
        ),
      );
    }

    return FuelCard(
      entry: _fuelManager.entries.first,
      onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => FuelForm(entry: _fuelManager.entries.first, isEditing: true,)));},
    );
  }

  Future<void> _addCar() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarPage()));
  }
}
  