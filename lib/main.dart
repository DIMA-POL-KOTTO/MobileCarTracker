import 'package:car_tracker/pages/home_page.dart';
import 'package:car_tracker/pages/fuel_page/fuel_page.dart';
import 'package:car_tracker/pages/maintenance_page.dart';
import 'package:car_tracker/pages/more_page/more_page.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/services/scan_manager.dart';

void main() {
  runApp(const CarCareApp());
}

class CarCareApp extends StatefulWidget {
  const CarCareApp({super.key});

  @override
  State<CarCareApp> createState() => _CarCareAppState();
}

class _CarCareAppState extends State<CarCareApp> {
  Locale? _locale;
  void changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarCare',
      theme: AppTheme.lightTheme,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', ''), // Русский
        Locale('en', ''), // Английский
      ],
      home: MainScreen(
        onChangeLanguage: changeLanguage,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final void Function(Locale) onChangeLanguage;
  const MainScreen({super.key, required this.onChangeLanguage});

  @override
  State<MainScreen> createState() => _MainScreenState();
  
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ScanManager _scanManager = ScanManager.instance;

  @override
  void initState(){
    super.initState();
    _scanManager.addListener(_onScanChanged);
  }

  @override
  void dispose() {
    _scanManager.removeListener(_onScanChanged);
    super.dispose();
  }

  void _onScanChanged() {
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> pages = [
      const HomePage(),
      const FuelPage(),
      const MaintenancePage(),
      MorePage(onChangeLanguage: widget.onChangeLanguage),
    ];
    final processingCount = _scanManager.scans.where((scan) => scan.status == ScanStatus.processing).length;
    return Scaffold(
      body: Stack(children: [
        pages[_selectedIndex],
        if (processingCount > 0)
          Positioned(right: 16, bottom: 16, child: _buildScanIndicator(processingCount),)
      ],),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        backgroundColor: AppTheme.backgroundColor,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.secondaryColor,

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_gas_station),
            label: l10n.fuel_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.build),
            label: l10n.maintenance_page,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: l10n.more_page,
          ),
        ],
      )
    );
  }

  Widget _buildScanIndicator(int count) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      color: AppTheme.primaryColor,
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), border: Border.all(color: AppTheme.primaryColor),),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5,),),
          const SizedBox(width: 10,),
          Text('Обработка: $count',
          style: const TextStyle(color: AppTheme.textColor),),
        ],
      ),
    ),
    );
  }
} 



