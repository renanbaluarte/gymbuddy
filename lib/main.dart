import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cronometro_screen.dart';
import 'execucao_screen.dart';
import 'qr_scanner_screen.dart';
import 'equipment_detail_screen.dart';
import 'criar_treino_screen.dart';
import 'chat_screen.dart';
import 'treinos_screen.dart';

void main() {
  runApp(const GymBuddyApp());
}

class GymBuddyApp extends StatelessWidget {
  const GymBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/cronometro': (context) => const CronometroScreen(),
        '/chat': (context) => const ChatScreen(),
        '/qrscanner': (context) => const QRScannerScreen(),
        '/treino': (context) => const TreinosScreen(),
      },
    );
  }
}
