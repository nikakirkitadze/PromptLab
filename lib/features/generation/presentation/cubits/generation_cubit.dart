import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/generation_job.dart';
import '../../domain/services/generation_service.dart';
import '../../domain/usecases/create_generation_job.dart';
import '../../domain/usecases/delete_generation_job.dart';
import '../../domain/usecases/load_saved_jobs.dart';
import '../../domain/usecases/persist_job.dart';
import '../mappers/job_card_mapper.dart';
import 'generation_state.dart';

class GenerationCubit extends Cubit<GenerationState> {
  final CreateGenerationJob _createGenerationJob;
  final DeleteGenerationJob _deleteGenerationJob;
  final LoadSavedJobs _loadSavedJobs;
  final PersistJob _persistJob;
  final GenerationService _generationService;

  /// Internal source of truth — domain entities.
  final List<GenerationJob> _jobs = [];

  /// Active stream subscriptions keyed by job ID.
  final Map<String, StreamSubscription<GenerationJob>> _subscriptions = {};

  GenerationCubit({
    required CreateGenerationJob createGenerationJob,
    required DeleteGenerationJob deleteGenerationJob,
    required LoadSavedJobs loadSavedJobs,
    required PersistJob persistJob,
    required GenerationService generationService,
  })  : _createGenerationJob = createGenerationJob,
        _deleteGenerationJob = deleteGenerationJob,
        _loadSavedJobs = loadSavedJobs,
        _persistJob = persistJob,
        _generationService = generationService,
        super(GenerationState.initial()) {
    _initialize();
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  Future<void> _initialize() async {
    final savedJobs = await _loadSavedJobs();
    _jobs.addAll(savedJobs);
    _emitJobsState(isInitialized: true);
    _resumeActiveJobs();
  }

  void _resumeActiveJobs() {
    for (final job in _jobs.where((j) => j.status.isActive)) {
      final stream = _generationService.resumeGeneration(job);
      _subscribeToJob(job.id, stream);
    }
  }

  // ---------------------------------------------------------------------------
  // User intents
  // ---------------------------------------------------------------------------

  void onPromptChanged(String value) {
    emit(state.copyWith(
      prompt: value,
      promptError: () => null,
    ));
  }

  void onGenerationTypeChanged(GenerationType type) {
    emit(state.copyWith(selectedType: type));
  }

  Future<void> onGeneratePressed() async {
    final prompt = state.prompt.trim();
    if (prompt.isEmpty) {
      emit(state.copyWith(promptError: () => 'Please enter a prompt'));
      return;
    }

    final job = await _createGenerationJob(prompt: prompt, type: state.selectedType);
    _jobs.insert(0, job);
    _emitJobsState();

    final stream = _generationService.startGeneration(job);
    _subscribeToJob(job.id, stream);
  }

  void onCancelPressed(String jobId) {
    _generationService.cancelGeneration(jobId);
  }

  Future<void> onRetryPressed(String jobId) async {
    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) return;

    // Cancel any lingering subscription
    await _subscriptions[jobId]?.cancel();
    _subscriptions.remove(jobId);

    final resetJob = _jobs[index].copyWith(
      status: GenerationStatus.queued,
      progress: 0,
      updatedAt: DateTime.now(),
      errorMessage: () => null,
    );

    _jobs[index] = resetJob;
    await _persistJob(resetJob);
    _emitJobsState();

    final stream = _generationService.startGeneration(resetJob);
    _subscribeToJob(jobId, stream);
  }

  Future<void> onDeletePressed(String jobId) async {
    await _subscriptions[jobId]?.cancel();
    _subscriptions.remove(jobId);

    _jobs.removeWhere((j) => j.id == jobId);
    await _deleteGenerationJob(jobId);
    _emitJobsState();
  }

  // ---------------------------------------------------------------------------
  // Stream management
  // ---------------------------------------------------------------------------

  void _subscribeToJob(String jobId, Stream<GenerationJob> stream) {
    _subscriptions[jobId]?.cancel();
    _subscriptions[jobId] = stream.listen(
      _onJobUpdated,
      onError: (Object error) => _onJobError(jobId, error.toString()),
      onDone: () => _subscriptions.remove(jobId),
    );
  }

  Future<void> _onJobUpdated(GenerationJob updatedJob) async {
    if (isClosed) return;

    final index = _jobs.indexWhere((j) => j.id == updatedJob.id);
    if (index == -1) return;

    _jobs[index] = updatedJob;
    await _persistJob(updatedJob);
    _emitJobsState();
  }

  void _onJobError(String jobId, String error) {
    if (isClosed) return;

    final index = _jobs.indexWhere((j) => j.id == jobId);
    if (index == -1) return;

    _jobs[index] = _jobs[index].copyWith(
      status: GenerationStatus.failed,
      errorMessage: () => error,
      updatedAt: DateTime.now(),
    );
    _emitJobsState();
  }

  // ---------------------------------------------------------------------------
  // State emission
  // ---------------------------------------------------------------------------

  void _emitJobsState({bool? isInitialized}) {
    if (isClosed) return;
    emit(state.copyWith(
      jobCards: JobCardMapper.fromEntities(_jobs),
      isInitialized: isInitialized,
    ));
  }

  // ---------------------------------------------------------------------------
  // Cleanup
  // ---------------------------------------------------------------------------

  @override
  Future<void> close() {
    for (final sub in _subscriptions.values) {
      sub.cancel();
    }
    _subscriptions.clear();
    _generationService.dispose();
    return super.close();
  }
}
