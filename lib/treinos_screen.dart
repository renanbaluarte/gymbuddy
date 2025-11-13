import 'package:flutter/material.dart';
import 'criar_treino_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TreinosScreen extends StatefulWidget {
  const TreinosScreen({super.key});

  @override
  State<TreinosScreen> createState() => _TreinosScreenState();
}

  /// Estrutura em memória contendo a lista de treinos.
  /// Cada treino possui os campos: `name` e `exercises` (lista de exercícios).
class _TreinosScreenState extends State<TreinosScreen> {
  List<Map<String, dynamic>> treinos = [];

  @override
  void initState() {
    super.initState();
    _loadTreinos();
  }

  /// Carrega os treinos persistidos no dispositivo.
  Future<void> _loadTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? treinosString = prefs.getString('treinos_lista');

    if (treinosString != null) {
      setState(() {
        treinos = List<Map<String, dynamic>>.from(json.decode(treinosString));
      });
    }
  }

  /// Salva os treinos em armazenamento local (JSON em SharedPreferences).
  Future<void> _saveTreinos() async {
    final prefs = await SharedPreferences.getInstance();
    final String treinosString = json.encode(treinos);
    await prefs.setString('treinos_lista', treinosString);
  }

  /// Navega para a tela de detalhe, retornando um treino possivelmente editado.
  void _navigateToDetalhe(int index) async {
    final updatedTreino = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => TreinoDetalheScreen(
          treino: Map<String, dynamic>.from(treinos[index]),
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
            ? Center(
          child: Text(
            "Vazio por enquanto",
            style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                color: Theme.of(context).colorScheme.error,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
              ),
              // Permite apagar rapidamente um treino com gesto de arrastar.
              // Apresenta também uma opção de desfazer via SnackBar.
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.onPrimary, size: 26),
                      onPressed: () => _navigateToDetalhe(index),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // Atalho para criar rapidamente um novo treino
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Tela de detalhe de um treino específico.
///
/// Permite marcar exercícios como concluídos e devolve o estado atualizado
/// ao retornar para a listagem.
class TreinoDetalheScreen extends StatefulWidget {
  final Map<String, dynamic> treino;

  const TreinoDetalheScreen({super.key, required this.treino});

  @override
  State<TreinoDetalheScreen> createState() => _TreinoDetalheScreenState();
}

class _TreinoDetalheScreenState extends State<TreinoDetalheScreen> {
  /// Cópia mutável do treino recebido para permitir alterações locais.
  late Map<String, dynamic> _treinoAtual;

  @override
  void initState() {
    super.initState();
    _treinoAtual = Map<String, dynamic>.from(widget.treino);
  }

  @override
  Widget build(BuildContext context) {
    // Intercepta o gesto de voltar para retornar o treino atualizado.
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_treinoAtual);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_treinoAtual["name"] ?? "Detalhe"),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: (_treinoAtual["exercises"] as List).length,
          itemBuilder: (context, index) {
            final exercicio = _treinoAtual["exercises"][index];
            return Card(
              child: ListTile(
                leading: Checkbox(
                  value: exercicio["done"] ?? false,
                  onChanged: (value) {
                    setState(() {
                      exercicio["done"] = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                title: Text(exercicio["name"] ?? ""),
                subtitle: Text("Repetições: ${exercicio["reps"] ?? ""}"),
              ),
            );
          },
        ),
      ),
    );
  }
}