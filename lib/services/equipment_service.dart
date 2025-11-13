import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/equipment.dart';

/// Serviço responsável por carregar e consultar equipamentos a partir de um JSON local.
class EquipmentService {
  /// Carrega a lista completa de equipamentos do arquivo em assets.
  Future<List<Equipment>> _loadEquipments() async {
    final String jsonString = await rootBundle.loadString('assets/data/equipments.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Equipment.fromJson(json)).toList();
  }

  /// Retorna um equipamento pelo seu identificador, ou `null` se não encontrado.
  Future<Equipment?> findEquipmentById(String id) async {
    final equipments = await _loadEquipments();
    try {
      return equipments.firstWhere((equipment) => equipment.id == id);
    } catch (e) {
      return null;
    }
  }
}