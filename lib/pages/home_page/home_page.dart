import 'package:car_tracker/pages/home_page/add_car_page.dart';
import 'package:car_tracker/services/car_manager.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/models/car.dart';

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
      return _buildEmptyCarCard();
    }
    final car = _carManager.cars.first;
    return _buildCarCard(car, l10n);
  }

  Widget _buildEmptyCarCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.directions_car,
              size: 64,
              color: AppTheme.primaryColor,
            ),

            const SizedBox(height: 16),

            const Text(
              'Автомобиль не добавлен',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Добавьте автомобиль, чтобы начать отслеживать его состояние и заправки.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Добавить автомобиль'),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCarPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildCarCard(Car car, AppLocalizations l10n,) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    car.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.current_mileage,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${car.mileage} ${l10n.km}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: null,
                  child: Text(l10n.update_btn),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  