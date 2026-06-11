import 'package:flutter/material.dart';
import 'package:psychological_assessment/core/design_system/app_theme.dart';

Color severityColor(String severity) {
  final s = severity.toLowerCase();
  if (s.contains('normal') || s.contains('no risk') || s.contains('no love')) {
    return Colors.green;
  }
  if (s.contains('mild') || s.contains('low')) return Colors.amber.shade700;
  if (s.contains('moderate') || s.contains('probable')) return Colors.orange;
  if (s.contains('extremely') ||
      s.contains('high') ||
      s.contains('excessive')) {
    return const Color(0xFFB71C1C);
  }
  if (s.contains('severe')) return Colors.red;
  return AppColors.textSecondary;
}

Color severityColorFromBand(String bandStatus, String currentSeverity) {
  if (bandStatus == currentSeverity) return severityColor(bandStatus);
  return severityColor(bandStatus).withValues(alpha: 0.35);
}
