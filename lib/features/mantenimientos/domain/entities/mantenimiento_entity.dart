import 'package:intl/intl.dart';

class MantenimientoEntity {
  final String id;
  final String vehiculoId;
  final String tipo;
  final double costo;
  final String? piezas;
  final DateTime fecha;
  final List<String> fotosUrls;
  final String? taller;
  final String? observaciones;

  const MantenimientoEntity({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.costo,
    this.piezas,
    required this.fecha,
    this.fotosUrls = const [],
    this.taller,
    this.observaciones,
  });

  String get costoFormatted => _formatMoney(costo);
  String get fechaFormatted => _formatDate(fecha);
  String get tipoIcon {
    switch (tipo.toLowerCase()) {
      case 'cambio de aceite':
        return '🔧';
      case 'frenos':
        return '🛑';
      case 'llantas':
        return '🛞';
      case 'motor':
        return '🔩';
      default:
        return '⚙️';
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
