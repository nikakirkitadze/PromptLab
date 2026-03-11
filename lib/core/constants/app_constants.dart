abstract final class AppConstants {
  static const String appTitle = 'PromptLab';
  static const String appSubtitle = 'AI Content Generation Studio';

  // Simulation timing
  static const int minQueueDelayMs = 1000;
  static const int maxQueueDelayMs = 2000;
  static const int minProcessingDurationMs = 3000;
  static const int maxProcessingDurationMs = 8000;
  static const int progressUpdateIntervalMs = 200;

  // Failure rate (0.0 to 1.0)
  static const double failureRate = 0.20;

  // Persistence
  static const String jobsBoxName = 'generation_jobs';
}
