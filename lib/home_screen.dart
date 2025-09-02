import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Futuro: abrir menu lateral
          },
        ),
        title: const Text('GymBuddy 🏋️'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Futuro: abrir perfil do usuário
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            _buildImageCard(
              screenWidth,
              'assets/images/treino.jpg',
              Icons.play_arrow,
                  () => Navigator.pushNamed(context, '/treino'),
            ),
            const SizedBox(height: 24),
            _buildImageCard(
              screenWidth,
              'assets/images/esteira.jpg',
              Icons.access_time,
                  () => Navigator.pushNamed(context, '/cronometro'),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/chat'),
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildImageCard(
      double screenWidth,
      String imagePath,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Align(
      alignment: Alignment.center, // garante centralização horizontal
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: screenWidth * 0.85,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.green,
              child: IconButton(
                icon: Icon(icon, color: Colors.black, size: 28),
                onPressed: onPressed,
                splashRadius: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
