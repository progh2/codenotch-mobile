import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/core/constants.dart';
import 'package:codenotch_mobile/core/mock_usage.dart';
import 'package:codenotch_mobile/core/usage_providers.dart';
import 'package:codenotch_mobile/core/widget_colors.dart';

void main() {
  test('mock payload stays mock-only', () {
    expect(HomeWidgetPlaceholder.title, 'Codenotch');
    expect(HomeWidgetPlaceholder.usage, '72%');
    expect(HomeWidgetPlaceholder.label, 'Claude');
    expect(HomeWidgetPlaceholder.percent, 72);
    expect(HomeWidgetIds.titleKey, 'title');
    expect(HomeWidgetIds.usageKey, 'usage');
    expect(HomeWidgetIds.labelKey, 'label');
    expect(HomeWidgetIds.percentKey, 'percent');
    expect(HomeWidgetIds.mockIndexKey, 'mock_index');
    expect(HomeWidgetIds.providerIdKey, 'provider_id');
    expect(HomeWidgetIds.enabledProvidersKey, 'enabled_providers');
  });

  test('native widget names match Android receiver and iOS kind', () {
    expect(HomeWidgetIds.android, 'CodenotchUsageWidget');
    expect(
      HomeWidgetIds.androidQualified,
      'com.progh2.codenotch_mobile.CodenotchUsageWidget',
    );
    expect(HomeWidgetIds.ios, 'CodenotchUsageWidget');
    expect(HomeWidgetIds.appGroup, 'group.com.progh2.codenotchMobile');
  });

  test('catalog cycles enabled provider percent and label', () {
    expect(MockUsageCatalog.initial.percentText, '72%');
    expect(MockUsageCatalog.initial.label, 'Claude');
    expect(MockUsageCatalog.initial.provider, UsageProvider.claude);
    expect(MockUsageCatalog.at(1).percentText, '41%');
    expect(MockUsageCatalog.at(1).label, 'Cursor');
    expect(MockUsageCatalog.at(2).percentText, '88%');
    expect(MockUsageCatalog.at(2).label, 'Codex');
    expect(MockUsageCatalog.at(3).percentText, '55%');
    expect(MockUsageCatalog.at(3).label, 'Antigravity');
    expect(MockUsageCatalog.nextIndex(3, 4), 0);

    const enabled = {UsageProvider.cursor, UsageProvider.codex};
    expect(MockUsageCatalog.at(0, enabled: enabled).label, 'Cursor');
    expect(MockUsageCatalog.at(1, enabled: enabled).label, 'Codex');
    expect(MockUsageCatalog.at(2, enabled: enabled).label, 'Cursor');
    expect(MockUsageCatalog.at(0, enabled: {}).label, 'No providers');
    expect(MockUsageCatalog.at(0, enabled: {}).percentText, '--');
  });

  test('locked widget palette is unchanged', () {
    expect(WidgetColors.background.toARGB32(), 0xFF0B0F14);
    expect(WidgetColors.ringTrack.toARGB32(), 0xFF1C2430);
    expect(WidgetColors.ringFill.toARGB32(), 0xFF5EEAD4);
    expect(WidgetColors.percent.toARGB32(), 0xFFF3F6FA);
    expect(WidgetColors.label.toARGB32(), 0xFF8B96A8);
  });

  test('Se-a ring metrics match the locked ratios', () {
    expect(UsageRingSpec.startDegrees, 135);
    expect(UsageRingSpec.sweepDegrees, 270);
    expect(UsageRingSpec.strokeWidth, 6);
    expect(UsageRingSpec.fillStrokeWidth, 6);
    expect(UsageRingSpec.highlightStartDegrees, 210);
    expect(UsageRingSpec.highlightSweepDegrees, 120);
    expect(UsageRingSpec.innerPaddingRatio, 0.12);
    expect(UsageRingSpec.percentHeightRatio, 0.28);
    expect(UsageRingSpec.labelToPercentRatio, 0.40);
    expect(
      WidgetColors.ringFillHighlight.toARGB32(),
      Color.lerp(
        WidgetColors.ringFill,
        WidgetColors.percent,
        UsageRingSpec.highlightMix,
      )!.toARGB32(),
    );
  });

  test('upper 120° highlight overlaps the fill arc', () {
    expect(UsageRingSpec.highlightArc(0), isNull);
    expect(UsageRingSpec.highlightArc(0.2), isNull);

    final mid = UsageRingSpec.highlightArc(0.41);
    expect(mid, isNotNull);
    expect(mid!.start, 210);
    expect(mid.sweep, closeTo(245.7 - 210, 0.05));

    final high = UsageRingSpec.highlightArc(0.88);
    expect(high, isNotNull);
    expect(high!.start, 210);
    expect(high.sweep, 120);
  });
}
