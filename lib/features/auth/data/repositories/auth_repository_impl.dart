import 'package:dartz/dartz.dart';
import 'package:taller_itla_app/features/auth/data/models/auth_response_model.dart';
import 'package:taller_itla_app/features/auth/data/models/perfil_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<Either<String, String>> registro(String matricula) async {
    try {
      final model = await dataSource.registro(matricula);
      // El registro devuelve un token temporal
      return Right(model.token);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> activarCuenta(
      String token, String contrasena) async {
    try {
      final model = await dataSource.activarCuenta(token, contrasena);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> login(
      String matricula, String contrasena) async {
    try {
      final model = await dataSource.login(matricula, contrasena);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> olvidarClave(String matricula) async {
    try {
      await dataSource.olvidarClave(matricula);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> getPerfil() async {
    try {
      final model = await dataSource.getPerfil();
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> updateFotoPerfil(String filePath) async {
    try {
      final model = await dataSource.updateFotoPerfil(filePath);
      return Right(model.toEntity());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
