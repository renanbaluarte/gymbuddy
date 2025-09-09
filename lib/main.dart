import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'cronometro_screen.dart';
import 'execucao_screen.dart'; // Import mantido conforme solicitado
import 'chat_screen.dart';
import 'treinos_screen.dart';
import 'criar_treino_screen.dart'; // Import mantido conforme solicitado

// 1. Transforme a função em async e o retorno em Future<void>
Future<void> main() async {
  // 2. Adicione esta linha para garantir a inicialização dos plugins
  WidgetsFlutterBinding.ensureInitialized();

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
        '/treino': (context) => const TreinosScreen(),

        // Adicione mais rotas conforme necessário
      },
    );
  }
}