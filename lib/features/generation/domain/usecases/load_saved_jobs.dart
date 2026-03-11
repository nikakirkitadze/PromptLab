import '../entities/generation_job.dart';
import '../repositories/generation_repository.dart';

class LoadSavedJobs {
  final GenerationRepository _repository;

  const LoadSavedJobs(this._repository);

  Future<List<GenerationJob>> call() => _repository.loadJobs();
}
