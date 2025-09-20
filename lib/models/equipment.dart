class Equipment {
  final String id;
  final String name;
  final String description;
  final String image;
  final String gif;
  final String instructions;
  final List<String> exercises;

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.gif,
    required this.instructions,
    required this.exercises,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    final exercisesFromJson = json['exercises'] as List<dynamic>?;
    final exercisesList = exercisesFromJson?.map((e) => e.toString()).toList() ?? [];

    return Equipment(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      gif: json['gif'] ?? '',
      instructions: json['instructions'] ?? '',
      exercises: exercisesList,
    );
  }
}