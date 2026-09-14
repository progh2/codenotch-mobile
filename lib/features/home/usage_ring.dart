import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/mock_usage.dart';
import '../../core/widget_colors.dart';

/// In-app ring that matches the Android / iOS home-widget geometry.
class UsageRing extends StatelessWidget {
  const UsageRing({
    super.key,
    required this.snapshot,
    this.size = 168,
  });

  final MockUsageSnapshot snapshot;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: UsageRingPainter(progress: snapshot.progress),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snapshot.percentText,
                  style: TextStyle(
                    color: WidgetColors.percent,
                    fontSize: size * 0.22,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  snapshot.label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: WidgetColors.label,
                    fontSize: size * 0.075,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UsageRingPainter extends CustomPainter {
  const UsageRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = UsageRingSpec.strokeWidth;
    final pad = stroke * UsageRingSpec.fillStrokeScale / 2 + 3;
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
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final fill = Paint()
      ..color = WidgetColors.ringFill
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke * UsageRingSpec.fillStrokeScale
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(rect, start, maxSweep, false, track);
    if (clamped > 0) {
      canvas.drawArc(rect, start, maxSweep * clamped, false, fill);
    }
  }

  @override
  bool shouldRepaint(covariant UsageRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
