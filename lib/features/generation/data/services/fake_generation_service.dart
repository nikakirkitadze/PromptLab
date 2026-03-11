import 'dart:async';
import 'dart:math';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/generation_job.dart';
import '../../domain/services/generation_service.dart';

class FakeGenerationService implements GenerationService {
  final Map<String, _JobRunner> _runners = {};

  @override
  Stream<GenerationJob> startGeneration(GenerationJob job) {
    _runners[job.id]?.cancel();

    final runner = _JobRunner(job: job, startProgress: 0);
    _runners[job.id] = runner;

    return runner.run().transform(
          StreamTransformer.fromHandlers(
            handleDone: (sink) {
              _runners.remove(job.id);
              sink.close();
            },
          ),
        );
  }

  @override
  Stream<GenerationJob> resumeGeneration(GenerationJob job) {
    if (!job.status.isActive) return const Stream.empty();

    _runners[job.id]?.cancel();

    final startProgress = job.status == GenerationStatus.processing ? job.progress : 0.0;
    final skipQueue = job.status == GenerationStatus.processing;

    final runner = _JobRunner(
      job: job,
      startProgress: startProgress,
      skipQueue: skipQueue,
    );
    _runners[job.id] = runner;

    return runner.run().transform(
          StreamTransformer.fromHandlers(
            handleDone: (sink) {
              _runners.remove(job.id);
              sink.close();
            },
          ),
        );
  }

  @override
  void cancelGeneration(String jobId) {
    _runners[jobId]?.cancel();
  }

  @override
  void dispose() {
    for (final runner in _runners.values) {
      runner.cancel();
    }
    _runners.clear();
  }
}

/// Encapsulates the simulation lifecycle of a single generation job.
class _JobRunner {
  final GenerationJob job;
  final double startProgress;
  final bool skipQueue;
  final Random _random = Random();
  final StreamController<GenerationJob> _controller = StreamController<GenerationJob>();

  bool _isCanceled = false;

  _JobRunner({
    required this.job,
    required this.startProgress,
    this.skipQueue = false,
  });

  Stream<GenerationJob> run() {
    _simulate();
    return _controller.stream;
  }

  void cancel() {
    _isCanceled = true;
  }

  Future<void> _simulate() async {
    try {
      // --- Queued phase ---
      if (!skipQueue) {
        _emit(GenerationStatus.queued, 0);

        final queueMs = AppConstants.minQueueDelayMs +
            _random.nextInt(AppConstants.maxQueueDelayMs - AppConstants.minQueueDelayMs);
        await _delay(queueMs);

        if (_checkCanceled()) return;
      }

      // --- Processing phase ---
      final totalMs = AppConstants.minProcessingDurationMs +
          _random.nextInt(
            AppConstants.maxProcessingDurationMs - AppConstants.minProcessingDurationMs,
          );
      final totalSteps = totalMs ~/ AppConstants.progressUpdateIntervalMs;
      final startStep = (startProgress * totalSteps).round();

      for (var step = startStep; step <= totalSteps; step++) {
        if (_checkCanceled()) return;

        final progress = (step / totalSteps).clamp(0.0, 1.0);
        _emit(GenerationStatus.processing, progress);

        if (step < totalSteps) {
          await _delay(AppConstants.progressUpdateIntervalMs);
        }
      }

      if (_checkCanceled()) return;

      // --- Result phase ---
      final shouldFail = _random.nextDouble() < AppConstants.failureRate;

      if (shouldFail) {
        _emit(GenerationStatus.failed, 1.0, errorMessage: _randomError());
      } else {
        _emit(GenerationStatus.completed, 1.0);
      }
    } catch (e) {
      if (!_controller.isClosed) {
        _emit(GenerationStatus.failed, job.progress, errorMessage: 'Unexpected error: $e');
      }
    } finally {
      if (!_controller.isClosed) {
        await _controller.close();
      }
    }
  }

  bool _checkCanceled() {
    if (_isCanceled && !_controller.isClosed) {
      _emit(GenerationStatus.canceled, job.progress);
      _controller.close();
      return true;
    }
    return false;
  }

  void _emit(GenerationStatus status, double progress, {String? errorMessage}) {
    if (_controller.isClosed) return;
    _controller.add(
      job.copyWith(
        status: status,
        progress: progress,
        updatedAt: DateTime.now(),
        errorMessage: errorMessage != null ? () => errorMessage : null,
      ),
    );
  }

  Future<void> _delay(int ms) => Future.delayed(Duration(milliseconds: ms));

  String _randomError() {
    const errors = [
      'GPU memory exceeded during generation',
      'Model inference timeout after 30s',
      'Content safety filter triggered',
      'Service temporarily overloaded',
      'Generation quality below acceptance threshold',
      'Resource allocation failed — try again',
    ];
    return errors[_random.nextInt(errors.length)];
  }
}
