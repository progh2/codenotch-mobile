/// App-level copy and identifiers. Live usage sync is out of scope for M1.
abstract final class AppInfo {
  static const name = 'Codenotch Mobile';
  static const tagline = 'Home-screen companion for AI usage';
}

/// Native home-widget identifiers used by [home_widget] and the platform shells.
///
/// Android application id is `com.progh2.codenotch_mobile`.
/// iOS bundle id is `com.progh2.codenotchMobile` (Flutter iOS default).
abstract final class HomeWidgetIds {
  static const android = 'CodenotchUsageWidget';
  static const androidQualified =
      'com.progh2.codenotch_mobile.CodenotchUsageWidget';
  static const ios = 'CodenotchUsageWidget';
  static const appGroup = 'group.com.progh2.codenotchMobile';
  static const titleKey = 'title';
  static const usageKey = 'usage';
  static const labelKey = 'label';
  static const percentKey = 'percent';
  static const mockIndexKey = 'mock_index';
}

/// Default mock payload written on launch. Refresh cycles [MockUsageCatalog].
abstract final class HomeWidgetPlaceholder {
  static const title = 'Codenotch';
  static const usage = '72%';
  static const label = 'Mock usage';
  static const percent = 72;
}
