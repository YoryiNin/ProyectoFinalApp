class CatalogoFiltros {
  final String? marca;
  final String? modelo;
  final String? anio;
  final String? precioMin;
  final String? precioMax;

  const CatalogoFiltros({
    this.marca,
    this.modelo,
    this.anio,
    this.precioMin,
    this.precioMax,
  });

  bool get estaVacio =>
      (marca == null || marca!.isEmpty) &&
      (modelo == null || modelo!.isEmpty) &&
      (anio == null || anio!.isEmpty) &&
      (precioMin == null || precioMin!.isEmpty) &&
      (precioMax == null || precioMax!.isEmpty);

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (marca != null && marca!.isNotEmpty) params['marca'] = marca;
    if (modelo != null && modelo!.isNotEmpty) params['modelo'] = modelo;
    if (anio != null && anio!.isNotEmpty) params['anio'] = anio;
    if (precioMin != null && precioMin!.isNotEmpty) {
      params['precioMin'] = precioMin;
    }
    if (precioMax != null && precioMax!.isNotEmpty) {
      params['precioMax'] = precioMax;
    }
    return params;
  }

  CatalogoFiltros copyWith({
    String? marca,
    String? modelo,
    String? anio,
    String? precioMin,
    String? precioMax,
  }) {
    return CatalogoFiltros(
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      precioMin: precioMin ?? this.precioMin,
      precioMax: precioMax ?? this.precioMax,
    );
  }
}
