import '../entities/generation_job.dart';

/// Contract for the generation execution engine.
///
/// Implementations simulate (or perform) the actual generation work,
/// emitting status updates as a stream.
abstract interface class GenerationService {
  /// Starts generation for a job from the beginning (queued phase).
  Stream<GenerationJob> startGeneration(GenerationJob job);

  /// Resumes generation for a job that was active when the app closed.
  /// Picks up from the job's current progress.
  Stream<GenerationJob> resumeGeneration(GenerationJob job);

  /// Cancels an actively running generation.
  void cancelGeneration(String jobId);

  /// Releases all resources.
  void dispose();
}
