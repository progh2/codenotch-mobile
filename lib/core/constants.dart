/// App-level copy and identifiers. Live usage sync is out of scope for M0.
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
}

/// Mock values written to both native widgets. Live usage lands in M1 (#4).
abstract final class HomeWidgetPlaceholder {
  static const title = 'Codenotch';
  static const usage = '--%';
}
