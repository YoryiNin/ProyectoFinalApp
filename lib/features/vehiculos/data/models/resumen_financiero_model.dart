import '../../domain/entities/resumen_financiero_entity.dart';

class ResumenFinancieroModel {
  final double totalMantenimientos;
  final double totalCombustible;
  final double totalGastos;
  final double totalIngresos;
  final double balance;

  ResumenFinancieroModel({
    required this.totalMantenimientos,
    required this.totalCombustible,
    required this.totalGastos,
    required this.totalIngresos,
    required this.balance,
  });

  factory ResumenFinancieroModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return ResumenFinancieroModel(
      totalMantenimientos: _parseDouble(data['total_mantenimientos']),
      totalCombustible: _parseDouble(data['total_combustible']),
      totalGastos: _parseDouble(data['total_gastos']),
      totalIngresos: _parseDouble(data['total_ingresos']),
      balance: _parseDouble(data['balance']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  ResumenFinancieroEntity toEntity() => ResumenFinancieroEntity(
        totalMantenimientos: totalMantenimientos,
        totalCombustible: totalCombustible,
        totalGastos: totalGastos,
        totalIngresos: totalIngresos,
        balance: balance,
      );
}
