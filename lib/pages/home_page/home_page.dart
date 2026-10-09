import 'package:car_tracker/pages/home_page/add_car_page.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:car_tracker/widgets/car_empty_card.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';
import 'package:car_tracker/widgets/car_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarManager _carManager = CarManager.instance;
  

  @override
  void initState() {
    super.initState();
    _carManager.addListener(_onCarChanged);
    _carManager.init();
  }

  @override
  void dispose() {
    _carManager.removeListener(_onCarChanged);
    super.dispose();
  }

  void _onCarChanged() {
    setState(() {});
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
    if (_carManager.cars.isEmpty) {
      return EmptyCarCard(onAdd: _addCar);
    }
    Car car = _carManager.cars.first;
    return CarCard(car: car, l10n: l10n, onDelete: () async {
      if (car.id == null) {
        return;
      }
      await _carManager.delete(car.id!);
    }, onUpdateMileage: (mileage) async {
      if (car.id == null) {
        return;
      }

      await _carManager.updateMileage(car.id!, mileage);
    },);
  }

  Future<void> _addCar() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarPage()));
  }
}
  