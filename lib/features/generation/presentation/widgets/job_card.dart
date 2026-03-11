import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/generation_job_card_model.dart';
import 'status_badge.dart';

class JobCard extends StatelessWidget {
  final GenerationJobCardModel model;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  const JobCard({
    super.key,
    required this.model,
    this.onCancel,
    this.onRetry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(model: model),
            if (model.showProgress) ...[
              const SizedBox(height: 16),
              _ProgressBar(progress: model.progress, color: model.statusColor),
            ],
            if (model.errorMessage != null) ...[
              const SizedBox(height: 14),
              _ErrorRow(message: model.errorMessage!),
            ],
            if (model.canCancel || model.canRetry || model.canDelete) ...[
              const SizedBox(height: 14),
              _Actions(
                canCancel: model.canCancel,
                canRetry: model.canRetry,
                canDelete: model.canDelete,
                onCancel: onCancel,
                onRetry: onRetry,
                onDelete: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final GenerationJobCardModel model;

  const _Header({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Type icon in white container
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(model.typeIcon, color: model.typeColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.prompt,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${model.typeLabel}  ·  ${model.timeAgo}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.gray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: StatusBadge(
            label: model.statusLabel,
            color: model.statusColor,
            backgroundColor: model.statusBackgroundColor,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;

  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Generating...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.gray,
              ),
            ),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: AppColors.white,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _ErrorRow extends StatelessWidget {
  final String message;

  const _ErrorRow({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline_rounded, size: 16, color: AppColors.failed),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.failed,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Actions extends StatelessWidget {
  final bool canCancel;
  final bool canRetry;
  final bool canDelete;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;

  const _Actions({
    required this.canCancel,
    required this.canRetry,
    required this.canDelete,
    this.onCancel,
    this.onRetry,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (canCancel)
          _PillButton(
            label: 'Cancel',
            color: AppColors.failed,
            outlined: true,
            onPressed: onCancel,
          ),
        if (canRetry) ...[
          _PillButton(
            label: 'Retry',
            color: AppColors.black,
            outlined: false,
            onPressed: onRetry,
          ),
          if (canDelete) const SizedBox(width: 8),
        ],
        if (canDelete)
          _PillButton(
            label: 'Delete',
            color: AppColors.gray,
            outlined: true,
            onPressed: onDelete,
          ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final VoidCallback? onPressed;

  const _PillButton({
    required this.label,
    required this.color,
    required this.outlined,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: outlined ? color : AppColors.white,
          backgroundColor: outlined ? Colors.transparent : color,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: outlined
                ? BorderSide(color: color.withValues(alpha: 0.3))
                : BorderSide.none,
          ),
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(label),
      ),
    );
  }
}
