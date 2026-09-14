import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'constants.dart';
import 'mock_usage.dart';
import 'usage_providers.dart';

/// Writes a mock usage snapshot into the Android App Widget and iOS WidgetKit
/// shells. Safe to call from [main] and the in-app refresh path.
///
/// Widget tests construct [CodenotchApp] without this so they do not hit the
/// native plugin. Failures here are logged and never blank the widget.
Future<void> syncMockHomeWidget({
  MockUsageSnapshot snapshot = MockUsageCatalog.initial,
  int index = 0,
  Set<UsageProvider> enabled = const {},
}) async {
  final enabledIds = enabled.isEmpty && snapshot.provider != null
      ? UsageProvider.all.map((provider) => provider.id).join(',')
      : (enabled.isEmpty
          ? ''
          : [
              for (final provider in UsageProvider.all)
                if (enabled.contains(provider)) provider.id,
            ].join(','));

  try {
    await HomeWidget.setAppGroupId(HomeWidgetIds.appGroup);
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.titleKey,
      HomeWidgetPlaceholder.title,
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.usageKey,
      snapshot.percentText,
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.labelKey,
      snapshot.label,
    );
    await HomeWidget.saveWidgetData<int>(
      HomeWidgetIds.percentKey,
      snapshot.percent,
    );
    await HomeWidget.saveWidgetData<int>(HomeWidgetIds.mockIndexKey, index);
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.providerIdKey,
      snapshot.provider?.id ?? '',
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.enabledProvidersKey,
      enabledIds,
    );
    await HomeWidget.updateWidget(
      name: HomeWidgetIds.android,
      androidName: HomeWidgetIds.android,
      iOSName: HomeWidgetIds.ios,
      qualifiedAndroidName: HomeWidgetIds.androidQualified,
    );
  } catch (error, stackTrace) {
    debugPrint('Home widget mock sync failed: $error\n$stackTrace');
  }
}

/// Backward-compatible alias used by [main].
Future<void> syncPlaceholderHomeWidget() => syncMockHomeWidget();
