import '../entities/generation_job.dart';

abstract interface class GenerationRepository {
  Future<List<GenerationJob>> loadJobs();
  Future<void> persistJob(GenerationJob job);
  Future<void> deleteJob(String jobId);
}
