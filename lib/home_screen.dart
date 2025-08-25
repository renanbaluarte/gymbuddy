import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior com título e ícones
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Ação futura para abrir o menu lateral
          },
        ),
        title: const Text('GymBuddy 🏋️'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Ação futura para abrir perfil do usuário
            },
          ),
        ],
      ),

      // Conteúdo principal
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            _buildImageCard(
              context,
              'assets/images/treino.jpg',
              Icons.play_arrow,
                  () {
                Navigator.pushNamed(context, '/treino');
              },
            ),
            const SizedBox(height: 24),
            _buildImageCard(
              context,
              'assets/images/esteira.jpg',
              Icons.access_time,
                  () {
                Navigator.pushNamed(context, '/cronometro');
              },
            ),
          ],
        ),
      ),

      // Dois botões flutuantes lado a lado
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botão de Chat
          FloatingActionButton(
            heroTag: "chatBtn", // <- evita conflito de Hero
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.chat),
          ),
          const SizedBox(width: 16),
          // Botão de QR Code
          FloatingActionButton(
            heroTag: "qrBtn",
            onPressed: () {
              Navigator.pushNamed(context, '/qrscanner');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Método que constrói os cards com imagem e botão
  Widget _buildImageCard(
      BuildContext context,
      String imagePath,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Center(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              width: MediaQuery.of(context).size.width * 0.85,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(icon, color: Colors.black, size: 30),
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
