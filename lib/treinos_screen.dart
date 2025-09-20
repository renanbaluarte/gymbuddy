import 'package:flutter/material.dart';
import 'criar_treino_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TreinosScreen extends StatefulWidget {
  const TreinosScreen({super.key});

  @override
  State<TreinosScreen> createState() => _TreinosScreenState();
}

class _TreinosScreenState extends State<TreinosScreen> {
  List<Map<String, dynamic>> treinos = [];

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  Future<void> _loadTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? treinosString = prefs.getString('treinos_lista');

    if (treinosString != null) {
      setState(() {
        treinos = List<Map<String, dynamic>>.from(json.decode(treinosString));
      });
    }
  }

  Future<void> _saveTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    final String treinosString = json.encode(treinos);
    await prefs.setString('treinos_lista', treinosString);
  }

  void _navigateToDetalhe(int index) async {
    final updatedTreino = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarTreinoScreen(
          onSave: (updatedTreino) {
            setState(() {
              treinos[index] = updatedTreino;
            });
            _saveTreinos();
          },
        ),
      ),
    );

    if (updatedTreino != null) {
      setState(() {
        treinos[index] = updatedTreino;
      });
      _saveTreinos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Treinos"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: treinos.isEmpty
            ? const Center(
          child: Text(
            "Vazio por enquanto",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          itemCount: treinos.length,
          itemBuilder: (context, index) {
            final treino = treinos[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                final removedTreino = treinos[index];
                setState(() {
                  treinos.removeAt(index);
                });
                _saveTreinos();

                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${removedTreino['name']} apagado."),
                    action: SnackBarAction(
                      label: "Desfazer",
                      onPressed: () {
                        setState(() {
                          treinos.insert(index, removedTreino);
                        });
                        _saveTreinos();
                      },
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    treino["name"],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  trailing: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.black, size: 26),
                      onPressed: () => _navigateToDetalhe(index),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CriarTreinoScreen(
                onSave: (novoTreino) {
                  setState(() {
                    treinos.add(novoTreino);
                  });
                  _saveTreinos();
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}