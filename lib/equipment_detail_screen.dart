import 'package:flutter/material.dart';
import '../models/equipment.dart';

class EquipmentDetailScreen extends StatelessWidget {
  final Equipment equipment;

  const EquipmentDetailScreen({Key? key, required this.equipment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(equipment.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            if (equipment.image.isNotEmpty)
              Center(
                child: Image.asset(
                  equipment.image,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),

            // Nome
            Text(
              equipment.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Descrição
            Text(
              equipment.description,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 24),

            // Instruções
            if (equipment.instructions.isNotEmpty) ...[
              const Text(
                "Como usar:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                equipment.instructions,
                style: const TextStyle(fontSize: 16),
              ),
            ],

            const SizedBox(height: 24),

            // Exercícios
            if (equipment.exercises.isNotEmpty) ...[
              const Text(
                "Exercícios sugeridos:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: equipment.exercises
                    .map((exercise) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("• $exercise",
                      style: const TextStyle(fontSize: 16)),
                ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
