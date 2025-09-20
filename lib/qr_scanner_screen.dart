import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'models/equipment.dart';
import 'services/equipment_service.dart';
import 'equipment_detail_screen.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  final EquipmentService _equipmentService = EquipmentService();
  bool _isProcessing = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _handleQRCode(String code) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final equipment = await _equipmentService.findEquipmentById(code);

    if (!mounted) return;

    if (equipment != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EquipmentDetailScreen(equipment: equipment),
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              _handleQRCode(barcode.rawValue!);
              break;
            }
          }
        },
      ),
    );
  }
}