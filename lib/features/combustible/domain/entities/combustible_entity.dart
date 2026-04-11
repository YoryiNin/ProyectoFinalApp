import 'package:intl/intl.dart';

class CombustibleEntity {
  final String id;
  final String vehiculoId;
  final String tipo; // 'combustible' o 'aceite'
  final double cantidad;
  final String unidad; // 'galones', 'litros', 'qt'
  final double monto;
  final DateTime fecha;

  const CombustibleEntity({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.monto,
    required this.fecha,
  });

  String get montoFormatted => _formatMoney(monto);
  String get fechaFormatted => _formatDate(fecha);
  String get displayTipo =>
      tipo == 'combustible' ? '⛽ Combustible' : '🔧 Aceite';
  String get displayUnidad {
    switch (unidad) {
      case 'galones':
        return 'gal';
      case 'litros':
        return 'L';
      case 'qt':
        return 'qt';
      default:
        return unidad;
    }
  }

  String _formatMoney(double value) {
    final formatter = NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$');
    return formatter.format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
