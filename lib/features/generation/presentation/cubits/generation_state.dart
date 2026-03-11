import 'package:equatable/equatable.dart';

import '../../domain/entities/generation_job.dart';
import '../models/generation_job_card_model.dart';

class GenerationState extends Equatable {
  final String prompt;
  final GenerationType selectedType;
  final List<GenerationJobCardModel> jobCards;
  final String? promptError;
  final bool isInitialized;

  const GenerationState({
    this.prompt = '',
    this.selectedType = GenerationType.image,
    this.jobCards = const [],
    this.promptError,
    this.isInitialized = false,
  });

  factory GenerationState.initial() => const GenerationState();

  bool get canGenerate => prompt.trim().isNotEmpty;

  GenerationState copyWith({
    String? prompt,
    GenerationType? selectedType,
    List<GenerationJobCardModel>? jobCards,
    String? Function()? promptError,
    bool? isInitialized,
  }) {
    return GenerationState(
      prompt: prompt ?? this.prompt,
      selectedType: selectedType ?? this.selectedType,
      jobCards: jobCards ?? this.jobCards,
      promptError: promptError != null ? promptError() : this.promptError,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [
        prompt,
        selectedType,
        jobCards,
        promptError,
        isInitialized,
      ];
}
