import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Para ler arquivos
import 'dart:convert'; // Para decodificar o JSON

/// Tela de criação de um novo treino.
///
/// Permite pesquisar exercícios disponíveis a partir de um JSON local
/// e montar uma lista com séries/repetições antes de salvar.
class CriarTreinoScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const CriarTreinoScreen({super.key, required this.onSave});

  @override
  State<CriarTreinoScreen> createState() => _CriarTreinoScreenState();
}

class _CriarTreinoScreenState extends State<CriarTreinoScreen> {
  // --- Controladores e Listas ---
  final TextEditingController _treinoController = TextEditingController();
  final TextEditingController _exercicioController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  List<Map<String, dynamic>> exerciciosAdicionados = [];

  // Lista para guardar todos os nomes de exercícios do JSON
  List<String> _todosOsExercicios = [];

  // --- Funções de Lógica ---

  @override
  void initState() {
    super.initState();
    _carregarExerciciosDoJson();
  }

  /// Lê a lista de exercícios do arquivo local em assets e extrai os nomes.
  Future<void> _carregarExerciciosDoJson() async {
    final String jsonString = await rootBundle.loadString('assets/exercicios.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    setState(() {
      _todosOsExercicios = jsonResponse.map((e) => e['name'].toString()).toList();
    });
  }

  /// Adiciona um item de exercício à lista do treino em construção.
  void _adicionarExercicio() {
    if (_exercicioController.text.isNotEmpty && _repsController.text.isNotEmpty) {
      setState(() {
        exerciciosAdicionados.add({
          "name": _exercicioController.text,
          "reps": _repsController.text,
          "done": false,
        });
        _exercicioController.clear();
        _repsController.clear();
        FocusScope.of(context).unfocus();
      });
    }
  }

  /// Consolida os dados do novo treino e devolve para a tela anterior.
  void _salvarTreino() {
    if (_treinoController.text.isNotEmpty && exerciciosAdicionados.isNotEmpty) {
      final novoTreino = {
        "name": _treinoController.text,
        "exercises": exerciciosAdicionados,
      };
      widget.onSave(novoTreino);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _treinoController.dispose();
    _exercicioController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Novo Treino"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _treinoController,
                decoration: const InputDecoration(
                  labelText: "Nome do Treino",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              const Text("Adicionar Exercício", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Em criar_treino_screen.dart, dentro do método build:

              // Campo com auto-completar para facilitar a busca de exercícios.
              Autocomplete<String>(
                // Esta função está correta e não precisa de mudanças
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  final suggestions = _todosOsExercicios.where((String option) {
                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                  return suggestions;
                },

                // Quando selecionado, atualiza o controller do exercício
                onSelected: (String selection) {
                  _exercicioController.text = selection;
                },

                // Constrói o campo de texto com o controller controlado pelo Autocomplete
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldController, // Este é o controller do Autocomplete
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {

                  return TextField(
                    // PONTO CRÍTICO: O TextField DEVE usar o controller do builder (fieldController)
                    controller: fieldController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                      labelText: "Pesquise o exercício...",
                      border: OutlineInputBorder(),
                    ),
                    // Adicionamos esta linha para manter nosso _exercicioController sempre atualizado,
                    // seja com uma sugestão ou com um texto digitado pelo usuário.
                    onChanged: (text) {
                      _exercicioController.text = text;
                    },
                  );
                },
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _repsController,
                      decoration: const InputDecoration(
                        labelText: "Séries e Reps (ex: 4x12)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    icon: const Icon(Icons.add),
                    onPressed: _adicionarExercicio,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text("Exercícios adicionados:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exerciciosAdicionados.length,
                itemBuilder: (context, index) {
                  final e = exerciciosAdicionados[index];
                  return Card(
                    child: ListTile(
                      title: Text(e["name"]),
                      subtitle: Text("Repetições: ${e["reps"]}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                        onPressed: () {
                          setState(() {
                            exerciciosAdicionados.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarTreino,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Salvar Treino", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}