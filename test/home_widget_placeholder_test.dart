import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/core/constants.dart';
import 'package:codenotch_mobile/core/mock_usage.dart';
import 'package:codenotch_mobile/core/widget_colors.dart';

void main() {
  test('mock payload stays mock-only', () {
    expect(HomeWidgetPlaceholder.title, 'Codenotch');
    expect(HomeWidgetPlaceholder.usage, '72%');
    expect(HomeWidgetPlaceholder.label, 'Mock usage');
    expect(HomeWidgetPlaceholder.percent, 72);
    expect(HomeWidgetIds.titleKey, 'title');
    expect(HomeWidgetIds.usageKey, 'usage');
    expect(HomeWidgetIds.labelKey, 'label');
    expect(HomeWidgetIds.percentKey, 'percent');
    expect(HomeWidgetIds.mockIndexKey, 'mock_index');
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

  test('catalog cycles mock percent and label', () {
    expect(MockUsageCatalog.initial.percentText, '72%');
    expect(MockUsageCatalog.initial.label, 'Mock usage');
    expect(MockUsageCatalog.nextIndex(0), 1);
    expect(MockUsageCatalog.at(1).percentText, '41%');
    expect(MockUsageCatalog.at(1).label, 'Sample quota');
    expect(MockUsageCatalog.at(2).percentText, '88%');
    expect(MockUsageCatalog.nextIndex(2), 0);
  });

  test('locked widget palette is unchanged', () {
    expect(WidgetColors.background.toARGB32(), 0xFF0B0F14);
    expect(WidgetColors.ringTrack.toARGB32(), 0xFF1C2430);
    expect(WidgetColors.ringFill.toARGB32(), 0xFF5EEAD4);
    expect(WidgetColors.percent.toARGB32(), 0xFFF3F6FA);
    expect(WidgetColors.label.toARGB32(), 0xFF8B96A8);
    expect(UsageRingSpec.startDegrees, 135);
    expect(UsageRingSpec.sweepDegrees, 270);
  });
}
