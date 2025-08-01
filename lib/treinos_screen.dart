import 'package:flutter/material.dart';

class TreinosScreen extends StatelessWidget {
  const TreinosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treinos = [
      {'titulo': 'Treino para as Costas', 'descricao': 'Exercícios para dorsais e lombar.'},
      {'titulo': 'Treino para as Pernas', 'descricao': 'Foco em quadríceps, posteriores e glúteos.'},
      {'titulo': 'Treino superior', 'descricao': 'Peito, ombro, tríceps e costas.'},
      {'titulo': 'Treino inferior', 'descricao': 'Reforço muscular para membros inferiores.'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GymBuddy 🏋️'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Ação futura para abrir menu
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Ação futura para abrir perfil
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: treinos.length,
        itemBuilder: (context, index) {
          final treino = treinos[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(treino['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(treino['descricao']!),
              trailing: Container(
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    // Futuro: iniciar execução do treino
                  },
                ),
              ),
            ),
          );
        },
      ),
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
}
