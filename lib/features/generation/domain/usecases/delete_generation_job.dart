import '../repositories/generation_repository.dart';

class DeleteGenerationJob {
  final GenerationRepository _repository;

  const DeleteGenerationJob(this._repository);

  Future<void> call(String jobId) => _repository.deleteJob(jobId);
}
