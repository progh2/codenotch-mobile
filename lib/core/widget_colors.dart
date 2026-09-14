import 'package:flutter/material.dart';

/// Locked home-widget palette. Do not invent other widget colors.
abstract final class WidgetColors {
  static const Color background = Color(0xFF0B0F14);
  static const Color ringTrack = Color(0xFF1C2430);
  static const Color ringFill = Color(0xFF5EEAD4);
  static const Color percent = Color(0xFFF3F6FA);
  static const Color label = Color(0xFF8B96A8);
}

/// Shared ring geometry for Flutter, Android, and iOS.
///
/// A 270° horseshoe starting at 135° (bottom-left) so the upper arc is the
/// longest continuous curve — the notch-like emphasis.
abstract final class UsageRingSpec {
  static const double startDegrees = 135;
  static const double sweepDegrees = 270;
  static const double strokeWidth = 6;
  static const double fillStrokeScale = 1.15;
}
