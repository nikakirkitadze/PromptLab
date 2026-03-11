import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/generation_job.dart';

class GenerationTypeSelector extends StatelessWidget {
  final GenerationType selected;
  final ValueChanged<GenerationType> onChanged;

  const GenerationTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: GenerationType.values.map((type) {
        final isSelected = type == selected;
        final isLast = type.index == GenerationType.values.length - 1;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 10),
            child: _TypeChip(
              label: type.label,
              icon: _typeIcon(type),
              isSelected: isSelected,
              onTap: () => onChanged(type),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _typeIcon(GenerationType type) => switch (type) {
        GenerationType.image => Icons.image_outlined,
        GenerationType.video => Icons.videocam_outlined,
        GenerationType.audio => Icons.audiotrack_outlined,
      };
}

class _TypeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? null
              : Border.all(color: AppColors.separator, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.white : AppColors.gray,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.white : AppColors.darkGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
