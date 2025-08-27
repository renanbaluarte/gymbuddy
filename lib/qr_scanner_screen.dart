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
  // --- Nossas propriedades combinadas ---
  final MobileScannerController controller = MobileScannerController();
  final EquipmentService _equipmentService = EquipmentService();
  bool _isProcessing = false;

  // --- Variável do flash comentada ---
  // bool flashOn = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // --- Método de flash comentado ---
  /* void _toggleFlash() {
    controller.toggleTorch();
    setState(() {
      flashOn = !flashOn;
    });
  }
  */

  // --- Nosso método robusto para lidar com o QR Code ---
  Future<void> _handleQRCode(String code) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    final equipment = await _equipmentService.findEquipmentById(code);

    if (!mounted) return;

    if (equipment != null) {
      controller.stop();
      await Navigator.push(
        context,
        MaterialPageRoute(
          // Navega para a nossa tela de detalhes REAL
          builder: (context) => EquipmentDetailScreen(equipment: equipment),
        ),
      );
      if (mounted) {
        controller.start();
        setState(() {
          _isProcessing = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Equipamento não encontrado.")),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leitor de QR Code"),
        backgroundColor: Colors.grey[200],
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (!_isProcessing) {
            final String? code = capture.barcodes.first.rawValue;
            if (code != null) {
              _handleQRCode(code);
            }
          }
        },
      ),
      // --- FloatingActionButton completamente comentado ---
      /* floatingActionButton: FloatingActionButton(
        onPressed: _toggleFlash,
        backgroundColor: Colors.green,
        child: Icon(
          flashOn ? Icons.flash_on : Icons.flash_off,
          color: flashOn ? Colors.yellow : Colors.white,
        ),
      ),
      */
    );
  }
}