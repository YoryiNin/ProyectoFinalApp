class IntegranteModel {
  final String nombre;
  final String matricula;
  final String telefono;
  final String telegram;
  final String correo;
  final String? fotoAsset; // 'assets/images/team/nombre.jpg' (opcional)
  final String rol;

  const IntegranteModel({
    required this.nombre,
    required this.matricula,
    required this.telefono,
    required this.telegram,
    required this.correo,
    this.fotoAsset,
    this.rol = 'Desarrollador',
  });
}

// ─── DATOS DEL EQUIPO — Edita aquí con los datos reales ───────────────────────
const List<IntegranteModel> equipoItla = [
  IntegranteModel(
    nombre: 'Yoryi Nin de la Rosa',
    matricula: '20231370',
    telefono: '+18094396346',
    telegram: 'YoryiNin',
    correo: 'Yoryi.Nin@itla.edu.do',
    rol: 'Líder de Proyecto',
  ),

  IntegranteModel(
    nombre: 'Hansell Bonilla Parra',
    matricula: '20230220',
    telefono: '+18098773432',
    telegram: 'TU_TELEGRAM',
    correo: '20230220@itla.edu.do',
    rol: 'Desarrollador',
  )
];


