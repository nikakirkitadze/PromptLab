import '../entities/generation_job.dart';
import '../repositories/generation_repository.dart';

class PersistJob {
  final GenerationRepository _repository;

  const PersistJob(this._repository);

  Future<void> call(GenerationJob job) => _repository.persistJob(job);
}
