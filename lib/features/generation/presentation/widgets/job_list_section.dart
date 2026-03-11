import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/generation_job_card_model.dart';
import 'empty_jobs_view.dart';
import 'job_card.dart';

class JobListSection extends StatelessWidget {
  final List<GenerationJobCardModel> jobs;
  final ValueChanged<String> onCancel;
  final ValueChanged<String> onRetry;
  final ValueChanged<String> onDelete;

  const JobListSection({
    super.key,
    required this.jobs,
    required this.onCancel,
    required this.onRetry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const Text(
              'Recent Jobs',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            if (jobs.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardFill,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${jobs.length}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (jobs.isEmpty)
          const EmptyJobsView()
        else
          ...jobs.map(
            (job) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: JobCard(
                model: job,
                onCancel: () => onCancel(job.id),
                onRetry: () => onRetry(job.id),
                onDelete: () => onDelete(job.id),
              ),
            ),
          ),
      ],
    );
  }
}
