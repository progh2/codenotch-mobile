import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/mock_usage.dart';
import '../../core/widget_colors.dart';

/// In-app ring that matches the Android / iOS home-widget geometry.
class UsageRing extends StatelessWidget {
  const UsageRing({super.key, required this.snapshot});

  final MockUsageSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final widgetHeight = height.isFinite ? height : width;
        final percentSize =
            widgetHeight * UsageRingSpec.percentHeightRatio;
        final labelSize = percentSize * UsageRingSpec.labelToPercentRatio;

        return CustomPaint(
          painter: UsageRingPainter(progress: snapshot.progress),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snapshot.percentText,
                  style: TextStyle(
                    color: WidgetColors.percent,
                    fontSize: percentSize,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                SizedBox(height: widgetHeight * 0.02),
                Text(
                  snapshot.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: WidgetColors.label,
                    fontSize: labelSize,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UsageRingPainter extends CustomPainter {
  const UsageRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final shortSide = math.min(size.width, size.height);
    final pad = shortSide * UsageRingSpec.innerPaddingRatio;
    final rect = Rect.fromLTWH(
      pad,
      pad,
      size.width - pad * 2,
      size.height - pad * 2,
    );
    final start = UsageRingSpec.startDegrees * math.pi / 180;
    final maxSweep = UsageRingSpec.sweepDegrees * math.pi / 180;
    final clamped = progress.clamp(0.0, 1.0);

    final track = Paint()
      ..color = WidgetColors.ringTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = UsageRingSpec.strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final fill = Paint()
      ..color = WidgetColors.ringFill
      ..style = PaintingStyle.stroke
      ..strokeWidth = UsageRingSpec.fillStrokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final highlight = Paint()
      ..color = WidgetColors.ringFillHighlight
      ..style = PaintingStyle.stroke
      ..strokeWidth = UsageRingSpec.fillStrokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(rect, start, maxSweep, false, track);
    if (clamped > 0) {
      canvas.drawArc(rect, start, maxSweep * clamped, false, fill);
      final band = UsageRingSpec.highlightArc(clamped);
      if (band != null) {
        canvas.drawArc(
          rect,
          band.start * math.pi / 180,
          band.sweep * math.pi / 180,
          false,
          highlight,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant UsageRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
