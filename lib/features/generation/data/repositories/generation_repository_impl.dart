import '../../domain/entities/generation_job.dart';
import '../../domain/repositories/generation_repository.dart';
import '../datasources/generation_local_datasource.dart';
import '../models/generation_job_model.dart';

class GenerationRepositoryImpl implements GenerationRepository {
  final GenerationLocalDatasource _localDatasource;

  const GenerationRepositoryImpl(this._localDatasource);

  @override
  Future<List<GenerationJob>> loadJobs() async {
    final models = _localDatasource.loadAll();
    final jobs = models.map((m) => m.toEntity()).toList();
    // Most recent first
    jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return jobs;
  }

  @override
  Future<void> persistJob(GenerationJob job) async {
    await _localDatasource.save(GenerationJobModel.fromEntity(job));
  }

  @override
  Future<void> deleteJob(String jobId) async {
    await _localDatasource.delete(jobId);
  }
}
