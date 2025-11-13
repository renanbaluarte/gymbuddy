import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

/// Tela responsável por executar o cronograma de treino com contagem regressiva.
///
/// Controla as fases de preparo, exercício e descanso, tocando sinais sonoros
/// a cada transição e exibindo o progresso visualmente.
class ExecucaoScreen extends StatefulWidget {
  final Duration workoutTime;
  final Duration restTime;
  final int totalSets;

  const ExecucaoScreen({
    super.key,
    required this.workoutTime,
    required this.restTime,
    required this.totalSets,
  });

  @override
  State<ExecucaoScreen> createState() => _ExecucaoScreenState();
}

class _ExecucaoScreenState extends State<ExecucaoScreen> {
  late Duration currentDuration;
  late Timer timer;
  int currentSet = 1;
  bool isWorkout = true;
  bool isPreparing = true;
  bool isRunning = true;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    currentDuration = const Duration(seconds: 5);
    _startTimer();
  }

  /// Inicia o timer periódico e decrementa o tempo restante.
  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isRunning) return;

      setState(() {
        if (currentDuration.inSeconds > 1) {
          currentDuration -= const Duration(seconds: 1);
        } else {
          _handleTimerTransition();
        }
      });
    });
  }

  /// Regras de transição entre preparo -> exercício -> descanso.
  /// Avança séries e finaliza quando todas tiverem sido concluídas.
  void _handleTimerTransition() {
    if (isPreparing) {
      isPreparing = false;
      isWorkout = true;
      currentDuration = widget.workoutTime;
      _playBeep();
    } else {
      if (!isWorkout) currentSet++;

      if (currentSet > widget.totalSets) {
        _playDone();
        timer.cancel();
        _showCompletedDialog();
        return;
      }

      isWorkout = !isWorkout;
      currentDuration = isWorkout ? widget.workoutTime : widget.restTime;
      _playBeep();
    }
  }

  /// Emite um beep para marcar a transição de fase.
  Future<void> _playBeep() async {
    await _audioPlayer.play(AssetSource('sounds/beep.mp3'));
  }

  /// Emite um som de conclusão ao finalizar todas as séries.
  Future<void> _playDone() async {
    await _audioPlayer.play(AssetSource('sounds/done.mp3'));
  }

  /// Mostra um diálogo simples ao concluir o treino.
  void _showCompletedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Treino Concluído!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalDuration = isPreparing
        ? const Duration(seconds: 5)
        : (isWorkout ? widget.workoutTime : widget.restTime);

    final percent = 1 -
        (currentDuration.inSeconds / totalDuration.inSeconds.clamp(1, 999));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Execução do Treino'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              timer.cancel();
              Navigator.pop(context);
            },
            child: const Text(
              'ENCERRAR',
              style: TextStyle(),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isPreparing
                    ? 'PREPARO'
                    : isWorkout
                    ? 'EXERCÍCIO'
                    : 'DESCANSO',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isPreparing
                      ? Theme.of(context).colorScheme.secondary
                      : isWorkout
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 12,
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isPreparing
                            ? Theme.of(context).colorScheme.secondary
                            : isWorkout
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    Text(
                      _formatDuration(currentDuration),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isPreparing
                    ? 'Prepare-se...'
                    : 'Repetição: $currentSet / ${widget.totalSets}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return duration.toString().substring(2, 7);
  }
}
