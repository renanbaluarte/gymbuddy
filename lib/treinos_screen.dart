import 'package:flutter/material.dart';
import 'criar_treino_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 1. Importar pacotes
import 'dart:convert';

class TreinosScreen extends StatefulWidget {
  const TreinosScreen({super.key});

  @override
  State<TreinosScreen> createState() => _TreinosScreenState();
}

class _TreinosScreenState extends State<TreinosScreen> {
  // A lista agora começa vazia e será preenchida pelo _loadTreinos
  List<Map<String, dynamic>> treinos = [];

  @override
  void initState() {
    super.initState();
    _loadTreinos(); // Carrega os treinos assim que a tela inicia
  }

  // NOVO: Função para carregar os treinos salvos
  Future<void> _loadTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    // Busca a string salva; se não houver nada, retorna null
    final String? treinosString = prefs.getString('treinos_lista');

    if (treinosString != null) {
      setState(() {
        // Decodifica a string JSON de volta para a lista de treinos
        treinos = List<Map<String, dynamic>>.from(json.decode(treinosString));
      });
    }
  }

  // NOVO: Função para salvar a lista de treinos atual
  Future<void> _saveTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    // Codifica a lista de treinos para uma string em formato JSON
    final String treinosString = json.encode(treinos);
    await prefs.setString('treinos_lista', treinosString);
  }

  // Função para navegar e atualizar um treino (checkboxes)
  void _navigateToDetalhe(int index) async {
    // Navega para a tela de detalhes e ESPERA um resultado quando ela for fechada
    final updatedTreino = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TreinoDetalheScreen(
          // Passamos uma cópia do treino para evitar bugs
          treino: Map<String, dynamic>.from(treinos[index]),
        ),
      ),
    );

    // Se a tela de detalhes retornou um treino atualizado, salvamos o estado
    if (updatedTreino != null) {
      setState(() {
        treinos[index] = updatedTreino;
      });
      _saveTreinos(); // Salva a lista com os checkboxes atualizados
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
                _saveTreinos(); // Salva a lista após remover um treino

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
                        _saveTreinos(); // Salva a lista se desfizer a remoção
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
                      onPressed: () => _navigateToDetalhe(index), // ATUALIZADO
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
                  _saveTreinos(); // Salva a lista após adicionar um novo treino
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

// --- Tela de Detalhes (modificada para retornar o estado) ---

class TreinoDetalheScreen extends StatefulWidget {
  final Map<String, dynamic> treino;

  const TreinoDetalheScreen({super.key, required this.treino});

  @override
  State<TreinoDetalheScreen> createState() => _TreinoDetalheScreenState();
}

class _TreinoDetalheScreenState extends State<TreinoDetalheScreen> {
  // Cópia local do treino para fazer as modificações
  late Map<String, dynamic> _treinoAtual;

  @override
  void initState() {
    super.initState();
    _treinoAtual = widget.treino;
  }

  @override
  Widget build(BuildContext context) {
    // PopScope intercepta o gesto de "voltar" para podermos retornar os dados atualizados
    return PopScope(
      canPop: false, // Impede o pop automático
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Quando o usuário for voltar, retornamos o treino modificado
        Navigator.of(context).pop(_treinoAtual);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_treinoAtual["name"]),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _treinoAtual["exercises"].length,
          itemBuilder: (context, index) {
            final exercicio = _treinoAtual["exercises"][index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: exercicio["done"],
                  onChanged: (value) {
                    // Modifica o estado na cópia local
                    setState(() {
                      exercicio["done"] = value!;
                    });
                  },
                  activeColor: Colors.green,
                ),
                title: Text(exercicio["name"]),
                subtitle: Text("Repetições: ${exercicio["reps"]}"),
              ),
            );
          },
        ),
      ),
    );
  }
}