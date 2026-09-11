import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'add_fuel_page.dart';

class FuelPage extends StatelessWidget {
  const FuelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.fuel_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold
        )
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      ),    
    ),
    floatingActionButton: FloatingActionButton(
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: AppTheme.backgroundColor,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddFuelPage(),
          ),
        );
      },
      child: const Icon(Icons.add, size: 31,),
    ),
  );
  }
}