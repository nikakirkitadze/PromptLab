import 'package:uuid/uuid.dart';

import '../entities/generation_job.dart';
import '../repositories/generation_repository.dart';

class CreateGenerationJob {
  final GenerationRepository _repository;

  const CreateGenerationJob(this._repository);

  Future<GenerationJob> call({
    required String prompt,
    required GenerationType type,
  }) async {
    final now = DateTime.now();
    final job = GenerationJob(
      id: const Uuid().v4(),
      prompt: prompt,
      type: type,
      status: GenerationStatus.queued,
      progress: 0,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.persistJob(job);
    return job;
  }
}
