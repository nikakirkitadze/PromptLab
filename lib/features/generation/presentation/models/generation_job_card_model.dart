import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A view-layer model that contains everything the UI needs to render
/// a single job card — no domain logic, only display-ready values.
class GenerationJobCardModel extends Equatable {
  final String id;
  final String prompt;
  final String typeLabel;
  final IconData typeIcon;
  final Color typeColor;
  final Color typeBackgroundColor;
  final String statusLabel;
  final Color statusColor;
  final Color statusBackgroundColor;
  final double progress;
  final bool showProgress;
  final String timeAgo;
  final String? errorMessage;
  final bool canCancel;
  final bool canRetry;
  final bool canDelete;

  const GenerationJobCardModel({
    required this.id,
    required this.prompt,
    required this.typeLabel,
    required this.typeIcon,
    required this.typeColor,
    required this.typeBackgroundColor,
    required this.statusLabel,
    required this.statusColor,
    required this.statusBackgroundColor,
    required this.progress,
    required this.showProgress,
    required this.timeAgo,
    this.errorMessage,
    required this.canCancel,
    required this.canRetry,
    required this.canDelete,
  });

  @override
  List<Object?> get props => [
        id,
        prompt,
        typeLabel,
        typeIcon,
        typeColor,
        typeBackgroundColor,
        statusLabel,
        statusColor,
        statusBackgroundColor,
        progress,
        showProgress,
        timeAgo,
        errorMessage,
        canCancel,
        canRetry,
        canDelete,
      ];
}
