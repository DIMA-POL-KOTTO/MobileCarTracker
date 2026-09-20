import 'package:car_tracker/pages/fuel_page/fuel_form.dart';
import 'package:car_tracker/services/scan_manager.dart';
import 'package:flutter/material.dart';
import 'package:car_tracker/theme/app_theme.dart';
import 'package:car_tracker/l10n/app_localizations.dart';
import 'add_fuel_page.dart';

class FuelPage extends StatefulWidget {
  const FuelPage({super.key});

  @override
  State<FuelPage> createState() => _FuelPageState();
}

class _FuelPageState extends State<FuelPage> {
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
    setState(() { });
  }
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _buildScanList(),
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

  Widget _buildScanList() {
    if (_scanManager.scans.isEmpty) {
      return const Center(
        child: Text('Заправок пока нет', style: TextStyle(color: AppTheme.textColor, fontSize: 16)),
      );
    }
    return ListView.separated(itemBuilder: (context, index) {
        final scan = _scanManager.scans[index];
        return _buildScanCard(scan);
      }, 
      separatorBuilder: (_, __) => const SizedBox(height: 12,), 
      itemCount: _scanManager.scans.length);
  }

  Widget _buildScanCard(ReceiptScan scan) {
    switch (scan.status) {
      case ScanStatus.processing:
        return _buildProcessingCard(scan);
      case ScanStatus.ready:
        return _buildReadyCard(scan);
      case ScanStatus.needsReview:
        return _buildNeedsReviewCard(scan);
      case ScanStatus.error:
        return _buildErrorCard(scan);
    }
  }

  Widget _buildProcessingCard(ReceiptScan scan) {
    return Card(
      child: ListTile(leading: 
        const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5,),),
        title: const Text('Обработка чека'),
        subtitle: const Text ('Распознавание данных...')
      ),
    );
  }

  Widget _buildReadyCard(ReceiptScan scan) {
    final data = scan.result;
    return Card(
      child: ListTile(leading: 
        const Icon(Icons.check_circle, color: Colors.green,),
        title: Text(data?.station ?? ''),
        subtitle: Text ('${data?.totalCost?.toStringAsFixed(2) ?? '-'} BYN',),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {_openFuelForm(scan);},
      ),
    );
  }

  Widget _buildNeedsReviewCard(ReceiptScan scan) {
    final data = scan.result;
    return Card(
      child: ListTile(leading: 
        const Icon(Icons.warning_amber_rounded, color: Colors.orange,),
        title: Text(data?.station ?? ''),
        subtitle: const Text ('Необходимо проверить данные'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (data != null) {
            _openFuelForm(scan);
          }
        },
      ),
    );
  }

  Widget _buildErrorCard(ReceiptScan scan) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.error, color: Colors.red,),
        title: const Text('Ошибка обработки'),
        subtitle: Text(scan.error ?? 'Не удалось распознать чек'),
      )
    );
  }

  void _openFuelForm(ReceiptScan scan) {
    if (scan.result == null) {
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => FuelForm(initialData: scan.result, isEditing: true, scan: scan,),));
  }
}