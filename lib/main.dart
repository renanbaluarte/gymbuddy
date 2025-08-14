import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cronometro_screen.dart';
import 'execucao_screen.dart';
// Import outras telas conforme forem criadas
import 'chat_screen.dart';
// import 'treino_screen.dart';

void main() {
  runApp(const GymBuddyApp());
}

class GymBuddyApp extends StatelessWidget {
  const GymBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBuddy',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),

      // Rotas nomeadas do app
      routes: {
        '/cronometro': (context) => const CronometroScreen(),
        '/chat': (context) => const ChatScreen(),
        // '/treino': (context) => const TreinoScreen(),
        // Adicione mais rotas conforme necessário
      },
    );
  }
}
