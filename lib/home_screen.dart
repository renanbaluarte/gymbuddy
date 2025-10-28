import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String appVersion = "Release 1.0.1";
    return Scaffold(
      appBar: AppBar(
        title: const Text('GymBuddy 🏋️'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Text(
                  'GymBuddy',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              title: const Text('Criador: Renan Ferreira'),
              dense: true,
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              title: Text('Versão $appVersion'),
              dense: true,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            _buildImageCard(
              context,
              'assets/images/treino.webp',
              Icons.play_arrow,
              () {
                Navigator.pushNamed(context, '/treino');
              },
            ),
            const SizedBox(height: 24),
            _buildImageCard(
              context,
              'assets/images/esteira.webp',
              Icons.access_time,
              () {
                Navigator.pushNamed(context, '/cronometro');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "chatBtn",
            onPressed: () {
              Navigator.pushNamed(context, '/chat');
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.chat),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: "qrBtn",
            onPressed: () {
              Navigator.pushNamed(context, '/qrscanner');
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.qr_code_scanner),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary, size: 30),
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