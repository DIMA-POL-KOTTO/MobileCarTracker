import 'package:car_tracker/pages/fuel_page/fuel_form.dart';
import 'package:car_tracker/services/scan_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'add_fuel_page.dart';
import 'scans_fuel_page.dart';
import 'package:car_tracker/services/fuel_manager.dart';
import 'package:car_tracker/models/fuel_entry.dart';
import 'package:car_tracker/utils.dart';
import 'package:car_tracker/widgets/fuel_card.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
  final ScanManager _scanManager = ScanManager.instance;
  final FuelManager _fuelManager = FuelManager.instance;
  bool _isSelectionMode = false;
  final Set<int> _selectedIds = {};
  @override
  void initState(){
    super.initState();
    _scanManager.addListener(_onScanChanged);
    _fuelManager.addListener(_onFuelChanged);
    _fuelManager.init();
  }
  @override
  void dispose() {
    _scanManager.removeListener(_onScanChanged);
    _fuelManager.removeListener(_onFuelChanged);
    super.dispose();
  }
  void _onScanChanged() {
    setState(() { });
  }
  void _onFuelChanged() {
    setState(() { });
  }
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode ? 'Выбрано: ${_selectedIds.length}' : l10n.fuel_page),
        titleTextStyle: const TextStyle(
          color: AppTheme.textColor,
          fontSize: 28,
          fontWeight: FontWeight.bold
        ),
        actions: [if (_isSelectionMode)
          IconButton(onPressed: _selectedIds.isEmpty ? null : _showDeleteConfirm, 
            icon: const Icon(Icons.delete))],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildFuelContent(),
      ),    
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_scanManager.scans.isNotEmpty) ...[
              FloatingActionButton(
              heroTag: 'scans_fuel_button',
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: const Color.fromARGB(255, 236, 216, 216),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScansFuelPage(),
                  ),
                );
              },
              child: Text('${_scanManager.scans.length}',
                style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12)
          ],
          FloatingActionButton(
            heroTag: 'add_fuel_button',
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
        ]
      ),
    );
  }

  Widget _buildFuelContent() {
    if (_fuelManager.entries.isEmpty) {
      return const Center(child: Text('Заправок пока нет', style: TextStyle(color: AppTheme.textColor, fontSize: 16)),);
    }
    final List<Widget> items = [];
    String? prevMonth;
    for (final entry in _fuelManager.entries) {
      final month = monthName(entry.date);
      if (month != prevMonth) {
        if (items.isNotEmpty) {
          items.add(const SizedBox(height: 16,));
        }
        items.add(
          Padding(padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(month,
              style: const TextStyle(
                color: AppTheme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        );
        prevMonth = month;
      }
      items.add(_buildFuelCard(entry));
      items.add(const SizedBox(height: 12,));
    }
    return ListView(children: items,);
  }

  Widget _buildFuelCard(FuelEntry entry) {
    if (entry.id == null) {
      return const SizedBox.shrink();
    }
    final id = entry.id!;
    final isSelected = _selectedIds.contains(entry.id);
    return FuelCard(
      entry: entry,
      leading: _isSelectionMode ? Checkbox(value: isSelected, onChanged: (_) => _toggleSelection(id)) : null,
      onLongPress: () {
        setState(() {
          _isSelectionMode = true;
          _selectedIds.add(id);
        });
      },
      onTap: _isSelectionMode ? () => _toggleSelection(id) : () {Navigator.push(context, MaterialPageRoute(builder: (context) => FuelForm(entry: entry, isEditing: true,)));},
    );
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      }
      else {
        _selectedIds.add(id);
      }
      if (_selectedIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  Future<void> _showDeleteConfirm() async {
    final confirmed = await showDialog(context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("Удалить заправки?"),
          content: Text('Выбрано ${_selectedIds.length}'),
          actions: [
            TextButton(onPressed: () {Navigator.pop(context, false);}, child: const Text('Отмена')),
            TextButton(onPressed: () {Navigator.pop(context, true);}, child: const Text('Удалить', style: TextStyle(color: Colors.red))),
          ],  
        );
      },
    );
    if (confirmed != true) {return;}
    await _fuelManager.deleteEntries(_selectedIds);
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }
}