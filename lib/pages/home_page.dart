import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.directions_car),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Passat B5",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("1999 ${l10n.year_point}"),
                            ],
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
                            "410 031 ${l10n.km}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: null, //пока ничего
                            child: Text(l10n.update_btn),
                          ),
                        ],
                      ),
                    ],    
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }