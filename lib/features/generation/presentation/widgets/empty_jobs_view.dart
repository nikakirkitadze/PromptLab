import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class EmptyJobsView extends StatelessWidget {
  const EmptyJobsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.cardFill,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.auto_awesome_outlined,
                size: 32,
                color: AppColors.lightGray,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No jobs yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Write a prompt and tap Generate\nto start your first job.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
