import 'package:flutter/material.dart';
// Telas principais do aplicativo
import 'home_screen.dart';
import 'cronometro_screen.dart';
import 'qr_scanner_screen.dart';
import 'chat_screen.dart';
import 'treinos_screen.dart';

/// Ponto de entrada da aplicação GymBuddy.
///
/// Responsável por executar o widget raiz [GymBuddyApp].
void main() {
  runApp(const GymBuddyApp());
}

/// Widget raiz da aplicação.
///
/// Centraliza definições de tema, rotas nomeadas e a tela inicial.
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
      // Tela inicial do app
      home: const HomeScreen(),
      // Rotas nomeadas para facilitar a navegação entre telas
      routes: {
        '/cronometro': (context) => const CronometroScreen(),
        '/chat': (context) => const ChatScreen(),
        '/qrscanner': (context) => const QRScannerScreen(),
        '/treino': (context) => const TreinosScreen(),
      },
    );
  }
}
