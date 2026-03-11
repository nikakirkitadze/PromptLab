import '../../domain/entities/generation_job.dart';

class GenerationJobModel {
  final String id;
  final String prompt;
  final String type;
  final String status;
  final double progress;
  final String createdAt;
  final String updatedAt;
  final String? errorMessage;

  const GenerationJobModel({
    required this.id,
    required this.prompt,
    required this.type,
    required this.status,
    required this.progress,
    required this.createdAt,
    required this.updatedAt,
    this.errorMessage,
  });

  factory GenerationJobModel.fromJson(Map<String, dynamic> json) {
    return GenerationJobModel(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      progress: (json['progress'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'type': type,
      'status': status,
      'progress': progress,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'errorMessage': errorMessage,
    };
  }

  factory GenerationJobModel.fromEntity(GenerationJob entity) {
    return GenerationJobModel(
      id: entity.id,
      prompt: entity.prompt,
      type: entity.type.name,
      status: entity.status.name,
      progress: entity.progress,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      errorMessage: entity.errorMessage,
    );
  }

  GenerationJob toEntity() {
    return GenerationJob(
      id: id,
      prompt: prompt,
      type: GenerationType.values.byName(type),
      status: GenerationStatus.values.byName(status),
      progress: progress,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      errorMessage: errorMessage,
    );
  }
}
