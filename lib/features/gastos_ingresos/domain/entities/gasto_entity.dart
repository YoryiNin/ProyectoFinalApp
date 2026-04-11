import 'package:intl/intl.dart';

class GastoEntity {
  final String id;
  final String vehiculoId;
  final String categoriaId;
  final String categoriaNombre;
  final double monto;
  final String descripcion;
  final DateTime fecha;

  const GastoEntity({
    required this.id,
    required this.vehiculoId,
    required this.categoriaId,
    required this.categoriaNombre,
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
