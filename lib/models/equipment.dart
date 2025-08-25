class Equipment {
  final String id;
  final String name;
  final String description;
  final String image; // Vamos manter 'image' e ajustar a tela, é mais fácil
  final String gif;
  final String instructions;     // <-- ADICIONADO
  final List<String> exercises; // <-- ADICIONADO

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.gif,
    required this.instructions, // <-- ADICIONADO
    required this.exercises,   // <-- ADICIONADO
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    // Garantir que a lista de exercícios seja lida corretamente do JSON
    final exercisesFromJson = json['exercises'] as List<dynamic>?;
    final exercisesList = exercisesFromJson?.map((e) => e.toString()).toList() ?? [];

    return Equipment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      gif: json['gif'] ?? '',
      instructions: json['instructions'] ?? '', // <-- ADICIONADO
      exercises: exercisesList,                 // <-- ADICIONADO
    );
  }
}