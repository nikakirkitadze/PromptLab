import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PromptInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String> onChanged;

  const PromptInputCard({
    super.key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    size: 17,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Your Prompt',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: 3,
              minLines: 2,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.black,
              ),
              decoration: InputDecoration(
                hintText: 'A futuristic cyberpunk city at night...',
                errorText: errorText,
                errorMaxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
