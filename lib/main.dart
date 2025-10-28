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
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF2E7D32),
      brightness: Brightness.light,
    );

    return MaterialApp(
      title: 'GymBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: scheme.inverseSurface,
          contentTextStyle: TextStyle(color: scheme.onInverseSurface),
          actionTextColor: scheme.primary,
        ),
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
