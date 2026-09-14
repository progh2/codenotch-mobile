import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/core/constants.dart';

void main() {
  test('placeholder payload stays mock-only', () {
    expect(HomeWidgetPlaceholder.title, 'Codenotch');
    expect(HomeWidgetPlaceholder.usage, '--%');
    expect(HomeWidgetIds.titleKey, 'title');
    expect(HomeWidgetIds.usageKey, 'usage');
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
}
