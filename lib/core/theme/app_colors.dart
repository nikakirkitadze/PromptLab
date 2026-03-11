import 'package:flutter/material.dart';

abstract final class AppColors {
  // Neutrals
  static const Color black = Color(0xFF1A1A1A);
  static const Color darkGray = Color(0xFF3C3C43);
  static const Color gray = Color(0xFF8E8E93);
  static const Color lightGray = Color(0xFFC7C7CC);
  static const Color separator = Color(0xFFE5E5EA);
  static const Color cardFill = Color(0xFFF2F2F7);
  static const Color white = Color(0xFFFFFFFF);

  // Generation type brand colors (used only on type icon accents)
  static const Color imageType = Color(0xFF8B5CF6);
  static const Color videoType = Color(0xFFE5447A);
  static const Color audioType = Color(0xFF0EA5E9);

  static const Color imageTypeBg = Color(0xFFF5F3FF);
  static const Color videoTypeBg = Color(0xFFFFF1F3);
  static const Color audioTypeBg = Color(0xFFF0F9FF);

  // Status colors (iOS system palette)
  static const Color queued = Color(0xFF8E8E93);
  static const Color processing = Color(0xFF007AFF);
  static const Color completed = Color(0xFF34C759);
  static const Color failed = Color(0xFFFF3B30);
  static const Color canceled = Color(0xFFFF9500);

  // Status tint backgrounds
  static const Color queuedBg = Color(0xFFF2F2F7);
  static const Color processingBg = Color(0xFFEBF3FF);
  static const Color completedBg = Color(0xFFEAFAF0);
  static const Color failedBg = Color(0xFFFFEBEB);
  static const Color canceledBg = Color(0xFFFFF5EB);
}
