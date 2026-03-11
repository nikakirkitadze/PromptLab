import 'package:equatable/equatable.dart';

enum GenerationType {
  image,
  video,
  audio;

  String get label => switch (this) {
        GenerationType.image => 'Image',
        GenerationType.video => 'Video',
        GenerationType.audio => 'Audio',
      };
}

enum GenerationStatus {
  queued,
  processing,
  completed,
  failed,
  canceled;

  String get label => switch (this) {
        GenerationStatus.queued => 'Queued',
        GenerationStatus.processing => 'Processing',
        GenerationStatus.completed => 'Completed',
        GenerationStatus.failed => 'Failed',
        GenerationStatus.canceled => 'Canceled',
      };

  bool get isTerminal => switch (this) {
        GenerationStatus.completed ||
        GenerationStatus.failed ||
        GenerationStatus.canceled =>
          true,
        _ => false,
      };

  bool get isActive => switch (this) {
        GenerationStatus.queued || GenerationStatus.processing => true,
        _ => false,
      };
}

class GenerationJob extends Equatable {
  final String id;
  final String prompt;
  final GenerationType type;
  final GenerationStatus status;
  final double progress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? errorMessage;

  const GenerationJob({
    required this.id,
    required this.prompt,
    required this.type,
    required this.status,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.errorMessage,
  });

  bool get canCancel => status == GenerationStatus.processing || status == GenerationStatus.queued;
  bool get canRetry => status == GenerationStatus.failed;
  bool get canDelete => status.isTerminal;

  GenerationJob copyWith({
    String? id,
    String? prompt,
    GenerationType? type,
    GenerationStatus? status,
    double? progress,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? Function()? errorMessage,
  }) {
    return GenerationJob(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      type: type ?? this.type,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        prompt,
        type,
        status,
        progress,
        createdAt,
        updatedAt,
        errorMessage,
      ];
}
