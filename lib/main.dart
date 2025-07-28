import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'treino_screen.dart';
import 'cronometro_screen.dart';
import 'chat_screen.dart';

void main() {
  runApp(const GymBuddyApp());
}

class GymBuddyApp extends StatelessWidget {
  const GymBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBuddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        //'/treino': (context) => const TreinoScreen(),
        //'/cronometro': (context) => const CronometroScreen(),
        //'/chat': (context) => const ChatScreen(),
      },
    );
  }
}
