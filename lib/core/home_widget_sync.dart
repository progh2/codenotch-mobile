import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'constants.dart';

/// Pushes the M0 placeholder into the Android App Widget and iOS WidgetKit shells.
///
/// Safe to call from [main] only. Widget tests construct [CodenotchApp] without
/// this so they do not hit the native plugin.
Future<void> syncPlaceholderHomeWidget() async {
  try {
    await HomeWidget.setAppGroupId(HomeWidgetIds.appGroup);
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.titleKey,
      HomeWidgetPlaceholder.title,
    );
    await HomeWidget.saveWidgetData<String>(
      HomeWidgetIds.usageKey,
      HomeWidgetPlaceholder.usage,
    );
    await HomeWidget.updateWidget(
      name: HomeWidgetIds.android,
      androidName: HomeWidgetIds.android,
      iOSName: HomeWidgetIds.ios,
      qualifiedAndroidName: HomeWidgetIds.androidQualified,
    );
  } catch (error, stackTrace) {
    debugPrint('Home widget placeholder sync failed: $error\n$stackTrace');
  }
}
