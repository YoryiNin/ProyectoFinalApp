import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Representa el vehículo actualmente seleccionado en la app.
/// Se usa para navegar a Mantenimientos, Combustible, Gomas y Gastos.
class SelectedVehicle {
  final String id;
  final String nombre; // Ej: "Toyota Corolla 2020"
  final String? foto;
  final String? placa;

  const SelectedVehicle({
    required this.id,
    required this.nombre,
    this.foto,
    this.placa,
  });

  @override
  String toString() => nombre;
}

final selectedVehicleProvider = StateProvider<SelectedVehicle?>((ref) => null);
