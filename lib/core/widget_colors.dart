import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Locked home-widget palette. Do not invent other widget colors.
abstract final class WidgetColors {
  static const Color background = Color(0xFF0B0F14);
  static const Color ringTrack = Color(0xFF1C2430);
  static const Color ringFill = Color(0xFF5EEAD4);
  static const Color percent = Color(0xFFF3F6FA);
  static const Color label = Color(0xFF8B96A8);

  /// Upper-120° fill highlight: lerp of locked fill → percent (no new hex).
  static Color get ringFillHighlight => Color.lerp(
        ringFill,
        percent,
        UsageRingSpec.highlightMix,
      )!;
}

/// Shared ring geometry and type ratios (Se-a metrics).
///
/// A 270° horseshoe starting at 135° (bottom-left). Fill and track are the
/// same stroke. Only the upper 120° of the fill is slightly brighter.
abstract final class UsageRingSpec {
  static const double startDegrees = 135;
  static const double sweepDegrees = 270;
  static const double strokeWidth = 6;
  static const double fillStrokeWidth = 6;
  static const double highlightStartDegrees = 210;
  static const double highlightSweepDegrees = 120;
  static const double highlightMix = 0.25;
  static const double innerPaddingRatio = 0.12;
  static const double percentHeightRatio = 0.28;
  static const double labelToPercentRatio = 0.40;

  /// Overlap of the fill arc with the upper 120° band, or `null` if none.
  static ({double start, double sweep})? highlightArc(double progress) {
    final fillEnd = startDegrees + sweepDegrees * progress.clamp(0.0, 1.0);
    final bandEnd = highlightStartDegrees + highlightSweepDegrees;
    final overlapStart = math.max(startDegrees, highlightStartDegrees);
    final overlapEnd = math.min(fillEnd, bandEnd);
    if (overlapEnd <= overlapStart) {
      return null;
    }
    return (start: overlapStart, sweep: overlapEnd - overlapStart);
  }
}
