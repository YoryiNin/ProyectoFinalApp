import 'package:dartz/dartz.dart';
import '../entities/goma_entity.dart';
import '../repositories/gomas_repository.dart';

class GetGomasUseCase {
  final GomasRepository repository;

  GetGomasUseCase(this.repository);

  Future<Either<String, List<GomaEntity>>> call(String vehiculoId) async {
    return repository.getGomas(vehiculoId);
  }
}
