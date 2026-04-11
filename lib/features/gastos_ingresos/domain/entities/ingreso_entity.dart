import 'package:intl/intl.dart';

class IngresoEntity {
  final String id;
  final String vehiculoId;
  final double monto;
  final String descripcion;
  final DateTime fecha;

  const IngresoEntity({
    required this.id,
    required this.vehiculoId,
    required this.monto,
    required this.descripcion,
    required this.fecha,
  });

  String get montoFormatted => _formatMoney(monto);
  String get fechaFormatted => DateFormat('dd/MM/yyyy').format(fecha);

  String _formatMoney(double value) {
    final formatter = NumberFormat.currency(locale: 'es_DO', symbol: 'RD\$');
    return formatter.format(value);
  }
}
