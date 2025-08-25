import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/equipment.dart'; // Importe sua classe Equipment

class EquipmentService {
  // Carrega a lista de equipamentos do arquivo JSON
  Future<List<Equipment>> _loadEquipments() async {
    final String jsonString = await rootBundle.loadString('assets/data/equipments.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Equipment.fromJson(json)).toList();
  }

  // Procura um equipamento específico pelo ID
  Future<Equipment?> findEquipmentById(String id) async {
    final equipments = await _loadEquipments();
    try {
      // Procura na lista o primeiro equipamento que tenha o ID correspondente
      return equipments.firstWhere((equipment) => equipment.id == id);
    } catch (e) {
      // Se 'firstWhere' não encontrar ninguém, ele joga uma exceção.
      // Nesse caso, retornamos null para indicar que não foi encontrado.
      return null;
    }
  }
}