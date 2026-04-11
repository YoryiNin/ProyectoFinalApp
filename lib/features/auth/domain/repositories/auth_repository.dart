import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<String, String>> registro(String matricula);
  Future<Either<String, UserEntity>> activarCuenta(
      String token, String contrasena);
  Future<Either<String, UserEntity>> login(String matricula, String contrasena);
  Future<Either<String, void>> olvidarClave(String matricula);
  Future<Either<String, UserEntity>> getPerfil();
  Future<Either<String, UserEntity>> updateFotoPerfil(String filePath);
}
