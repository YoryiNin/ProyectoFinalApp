import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taller_itla_app/theme/app_colors.dart';

enum GomaEstado { buena, regular, mala, reemplazada }

extension GomaEstadoExtension on GomaEstado {
  String get display {
    switch (this) {
      case GomaEstado.buena:
        return 'Buena';
      case GomaEstado.regular:
        return 'Regular';
      case GomaEstado.mala:
        return 'Mala';
      case GomaEstado.reemplazada:
        return 'Reemplazada';
    }
  }

  Color get color {
    switch (this) {
      case GomaEstado.buena:
        return AppColors.gomaGood;
      case GomaEstado.regular:
        return AppColors.gomaRegular;
      case GomaEstado.mala:
        return AppColors.gomaBad;
      case GomaEstado.reemplazada:
        return AppColors.gomaReplaced;
    }
  }

  static GomaEstado fromString(String value) {
    switch (value.toLowerCase()) {
      case 'buena':
        return GomaEstado.buena;
      case 'regular':
        return GomaEstado.regular;
      case 'mala':
        return GomaEstado.mala;
      case 'reemplazada':
        return GomaEstado.reemplazada;
      default:
        return GomaEstado.regular;
    }
  }
}

class PinchazoEntity {
  final String id;
  final String gomaId;
  final String descripcion;
  final DateTime fecha;

  const PinchazoEntity({
    required this.id,
    required this.gomaId,
    required this.descripcion,
    required this.fecha,
  });

  String get fechaFormatted => DateFormat('dd/MM/yyyy').format(fecha);
}

class GomaEntity {
  final String id;
  final String vehiculoId;
  final String posicion;
  final String eje;
  final GomaEstado estado;
  final List<PinchazoEntity> pinchazos;

  const GomaEntity({
    required this.id,
    required this.vehiculoId,
    required this.posicion,
    required this.eje,
    required this.estado,
    this.pinchazos = const [],
  });

  String get displayPosicion {
    switch (posicion) {
      case 'DelanteraIzq':
        return 'Delantera Izquierda';
      case 'DelanteroDer':
        return 'Delantera Derecha';
      case 'TraseroIzq':
        return 'Trasera Izquierda';
      case 'TraseroDer':
        return 'Trasera Derecha';
      default:
        return posicion;
    }
  }
}
