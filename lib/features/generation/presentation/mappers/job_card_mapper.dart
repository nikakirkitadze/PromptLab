import 'package:flutter/material.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/generation_job.dart';
import '../models/generation_job_card_model.dart';

abstract final class JobCardMapper {
  static List<GenerationJobCardModel> fromEntities(List<GenerationJob> jobs) {
    return jobs.map(fromEntity).toList();
  }

  static GenerationJobCardModel fromEntity(GenerationJob job) {
    return GenerationJobCardModel(
      id: job.id,
      prompt: job.prompt,
      typeLabel: job.type.label,
      typeIcon: _typeIcon(job.type),
      typeColor: _typeColor(job.type),
      typeBackgroundColor: _typeBgColor(job.type),
      statusLabel: job.status.label,
      statusColor: _statusColor(job.status),
      statusBackgroundColor: _statusBgColor(job.status),
      progress: job.progress,
      showProgress: job.status == GenerationStatus.queued || job.status == GenerationStatus.processing,
      timeAgo: job.createdAt.timeAgo,
      errorMessage: job.errorMessage,
      canCancel: job.canCancel,
      canRetry: job.canRetry,
      canDelete: job.canDelete,
    );
  }

  static IconData _typeIcon(GenerationType type) => switch (type) {
        GenerationType.image => Icons.image_rounded,
        GenerationType.video => Icons.videocam_rounded,
        GenerationType.audio => Icons.audiotrack_rounded,
      };

  static Color _typeColor(GenerationType type) => switch (type) {
        GenerationType.image => AppColors.imageType,
        GenerationType.video => AppColors.videoType,
        GenerationType.audio => AppColors.audioType,
      };

  static Color _typeBgColor(GenerationType type) => switch (type) {
        GenerationType.image => AppColors.imageTypeBg,
        GenerationType.video => AppColors.videoTypeBg,
        GenerationType.audio => AppColors.audioTypeBg,
      };

  static Color _statusColor(GenerationStatus status) => switch (status) {
        GenerationStatus.queued => AppColors.queued,
        GenerationStatus.processing => AppColors.processing,
        GenerationStatus.completed => AppColors.completed,
        GenerationStatus.failed => AppColors.failed,
        GenerationStatus.canceled => AppColors.canceled,
      };

  static Color _statusBgColor(GenerationStatus status) => switch (status) {
        GenerationStatus.queued => AppColors.queuedBg,
        GenerationStatus.processing => AppColors.processingBg,
        GenerationStatus.completed => AppColors.completedBg,
        GenerationStatus.failed => AppColors.failedBg,
        GenerationStatus.canceled => AppColors.canceledBg,
      };
}
