import 'package:car_tracker/services/scan_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'add_fuel_page.dart';
import 'scans_fuel_page.dart';
import 'package:car_tracker/services/fuel_manager.dart';
import 'package:car_tracker/models/fuel_entry.dart';
import 'package:car_tracker/utils.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
  final ScanManager _scanManager = ScanManager.instance;
  final FuelManager _fuelManager = FuelManager.instance;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  List<FuelEntry> _fuelEntries = [];
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
              foregroundColor: AppTheme.backgroundColor,
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
    return ListView.separated(itemBuilder: ((context, index) {
      final entry = _fuelManager.entries[index];
      return _buildFuelCard(entry);
    }), 
      separatorBuilder: (_,__) => const SizedBox(height: 12,), 
      itemCount: _fuelManager.entries.length);
  }

  Widget _buildFuelCard(FuelEntry entry) {
    final isSelected = _selectedIds.contains(entry.id);
    return Card(
      child: ListTile(
        leading: _isSelectionMode ? Checkbox(value: isSelected, onChanged: (_) {_toggleSelection(entry.id);},) : null,
        title: Text(
          entry.station,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        subtitle: Text(
          '${formatDate(entry.date)}\n'
          '${fuelTypeName(entry.fuelType)} · '
          '${entry.amount.toStringAsFixed(2)} л · '
          '${entry.totalCost.toStringAsFixed(2)} BYN',
        ),
        isThreeLine: true,
        onLongPress: () {
          setState(() {
            _isSelectionMode = true;
            _selectedIds.add(entry.id);
          });
        },
        onTap: _isSelectionMode ? () => _toggleSelection(entry.id) : null,
      ),
    );
  }

  void _toggleSelection(String id) {
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