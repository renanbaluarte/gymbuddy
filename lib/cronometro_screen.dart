import 'package:flutter/material.dart';
import 'execucao_screen.dart';

class CronometroScreen extends StatefulWidget {
  const CronometroScreen({super.key});

  @override
  State<CronometroScreen> createState() => _CronometroScreenState();
}

class _CronometroScreenState extends State<CronometroScreen> {
  Duration workoutTime = const Duration(seconds: 60);
  Duration restTime = const Duration(seconds: 30);
  int sets = 4;

  void _increaseWorkout() {
    setState(() {
      workoutTime += const Duration(seconds: 5);
    });
  }

  void _decreaseWorkout() {
    setState(() {
      if (workoutTime.inSeconds > 5) {
        workoutTime -= const Duration(seconds: 5);
      }
    });
  }

  void _increaseRest() {
    setState(() {
      restTime += const Duration(seconds: 5);
    });
  }

  void _decreaseRest() {
    setState(() {
      if (restTime.inSeconds > 5) {
        restTime -= const Duration(seconds: 5);
      }
    });
  }

  void _increaseSets() {
    setState(() {
      sets += 1;
    });
  }

  void _decreaseSets() {
    setState(() {
      if (sets > 1) sets -= 1;
    });
  }

  String _formatDuration(Duration d) =>
      d.toString().substring(2, 7); // Ex: "00:45"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Treino'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Defina os parâmetros do treino:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Tempo de Exercício
            _buildTimerControl(
              label: 'Tempo de Exercício',
              value: _formatDuration(workoutTime),
              onIncrement: _increaseWorkout,
              onDecrement: _decreaseWorkout,
            ),
            const SizedBox(height: 24),

            // Tempo de Descanso
            _buildTimerControl(
              label: 'Tempo de Descanso',
              value: _formatDuration(restTime),
              onIncrement: _increaseRest,
              onDecrement: _decreaseRest,
            ),
            const SizedBox(height: 24),

            // Número de Repetições
            _buildTimerControl(
              label: 'Repetições',
              value: sets.toString(),
              onIncrement: _increaseSets,
              onDecrement: _decreaseSets,
            ),

            const Spacer(),

            // Botão de Início
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Iniciar Treino'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExecucaoScreen(
                      workoutTime: workoutTime,
                      restTime: restTime,
                      totalSets: sets,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerControl({
    required String label,
    required String value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
              iconSize: 32,
            ),
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 32,
            ),
          ],
        ),
      ],
    );
  }
}
