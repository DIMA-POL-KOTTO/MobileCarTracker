import 'package:car_tracker/pages/home_page.dart';
import 'package:car_tracker/pages/fuel_page/fuel_page.dart';
import 'package:car_tracker/pages/maintenance_page.dart';
import 'package:car_tracker/pages/more_page.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CarCareApp());
}

class CarCareApp extends StatelessWidget {
  const CarCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarCare',
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
  
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FuelPage(),
    MaintenancePage(),
    MorePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        backgroundColor: AppTheme.backgroundColor,

        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.secondaryColor,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: 'Заправки',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'ТО',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Ещё',
          ),
        ],
      )
    );
  }
}



