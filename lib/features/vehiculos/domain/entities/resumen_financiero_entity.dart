import 'package:intl/intl.dart';

class ResumenFinancieroEntity {
  final double totalMantenimientos;
  final double totalCombustible;
  final double totalGastos;
  final double totalIngresos;
  final double balance;

  const ResumenFinancieroEntity({
    required this.totalMantenimientos,
    required this.totalCombustible,
    required this.totalGastos,
    required this.totalIngresos,
    required this.balance,
  });

  String get totalMantenimientosFormatted => _formatMoney(totalMantenimientos);
  String get totalCombustibleFormatted => _formatMoney(totalCombustible);
  String get totalGastosFormatted => _formatMoney(totalGastos);
  String get totalIngresosFormatted => _formatMoney(totalIngresos);
  String get balanceFormatted => _formatMoney(balance);

  String _formatMoney(double value) {
    final formatter = NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$');
    return formatter.format(value);
  }
}
