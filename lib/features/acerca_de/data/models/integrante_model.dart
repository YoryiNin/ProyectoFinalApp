import 'package:flutter/material.dart';

class IntegranteModel {
  final String? fotoAsset;
  final String nombre;
  final String matricula;
  final String telefono;
  final String telegram;
  final String correo;
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

// ——— DATOS DEL EQUIPO ———
const List<IntegranteModel> equipoItla = [
  // 👑 Líder
  IntegranteModel(
    nombre: 'Yoryi Nin de la Rosa',
    matricula: '20231370',
    telefono: '+18094396346',
    telegram: 'YoryiNin',
    correo: 'Yoryi.Nin@itla.edu.do',
    rol: 'Líder de Proyecto',
    fotoAsset: 'assets/images/team/mi_foto.jpg',
  ),

// 👤 Marcell Canario
  IntegranteModel(
    nombre: 'Marcell Junior Canario Jiminian',
    matricula: '2020-9759',
    telefono: '+18092644746',
    telegram: 'MarcellCanario',
    correo: '20209759@itla.edu.do',
    rol: 'Desarrollador',
    fotoAsset: 'assets/images/team/marcell.jpg',
  ),
  // 👤 Hansell
  IntegranteModel(
    nombre: 'Hansell Bonilla Parra',
    matricula: '20230220',
    telefono: '+18098773342',
    telegram: 'Hansell Bonilla',
    correo: '20230220@itla.edu.do',
    rol: 'Desarrollador',
  ),

  // 👤 Robertson
  IntegranteModel(
    nombre: 'Robertson Stiwel Matos Suero.',
    matricula: '20231581',
    telefono: '+18495130829',
    telegram: 'ValoyValoy',
    correo: '20231581@itla.edu.do',
    rol: 'Desarrollador',
    fotoAsset: 'assets/images/team/robertson.jpg',
  ),

  // 👤 Ismael
  IntegranteModel(
    nombre: 'George Ismael Hodge Abad',
    matricula: '2022-0469',
    telefono: '+18295578263',
    telegram: 'G.I',
    correo: '20220469@itla.edu.do',
    rol: 'Desarrollador',
    fotoAsset: 'assets/images/team/Abad.jpeg',
  ),
];
