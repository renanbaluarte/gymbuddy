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

      // Conteúdo principal da tela
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card do Treino
            _buildImageCard(
              context,
              'assets/images/treino.jpg',
              Icons.play_arrow,
                  () {
                Navigator.pushNamed(context, '/treino');
              },
            ),
            const SizedBox(height: 16),
            // Card do Cronômetro
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

      // Botão flutuante central para abrir o chat com IA
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/chat');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// Constrói um card visual com imagem, botão redondo e ação personalizada
  Widget _buildImageCard(
      BuildContext context,
      String imagePath,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Center(
      child: Stack(
        children: [
          // Imagem com cantos arredondados e largura reduzida
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imagePath,
              height: 180,
              width: MediaQuery.of(context).size.width * 0.85,
              fit: BoxFit.cover,
            ),
          ),
          // Botão verde redondo no canto inferior direito
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(icon, color: Colors.black, size: 20),
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
