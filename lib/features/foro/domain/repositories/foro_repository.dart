import 'package:dartz/dartz.dart';
import '../entities/tema_entity.dart';

abstract class ForoRepository {
  // Públicos (solo lectura)
  Future<Either<String, List<TemaEntity>>> getTemas();
  Future<Either<String, TemaEntity>> getTemaDetalle(String id);

  // Autenticados (requieren login)
  Future<Either<String, TemaEntity>> crearTema(
      String vehiculoId, String titulo, String descripcion);
  Future<Either<String, RespuestaEntity>> responderTema(
      String temaId, String contenido);
  Future<Either<String, List<TemaEntity>>> getMisTemas();
}
