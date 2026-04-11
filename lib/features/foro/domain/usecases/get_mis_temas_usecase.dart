import 'package:dartz/dartz.dart';
import '../entities/tema_entity.dart';
import '../repositories/foro_repository.dart';

class GetMisTemasUseCase {
  final ForoRepository repository;
  GetMisTemasUseCase(this.repository);

  Future<Either<String, List<TemaEntity>>> call() async {
    return repository.getMisTemas();
  }
}
