import 'usage_providers.dart';

/// One mock usage frame written to native widgets and the in-app preview.
class MockUsageSnapshot {
  const MockUsageSnapshot({
    required this.provider,
    required this.percent,
  });

  final UsageProvider? provider;
  final int percent;

  String get label => provider?.label ?? emptyLabel;

  String get percentText => provider == null ? emptyPercentText : '$percent%';

  double get progress => provider == null ? 0 : (percent.clamp(0, 100)) / 100;

  bool get isEmpty => provider == null;

  static const emptyPercentText = '--';
  static const emptyLabel = 'No providers';

  static const empty = MockUsageSnapshot(provider: null, percent: 0);
}

/// Cycling mock catalog keyed by [UsageProvider]. No live provider APIs.
abstract final class MockUsageCatalog {
  static const initial = MockUsageSnapshot(
    provider: UsageProvider.claude,
    percent: 72,
  );

  static const snapshots = [
    initial,
    MockUsageSnapshot(provider: UsageProvider.cursor, percent: 41),
    MockUsageSnapshot(provider: UsageProvider.codex, percent: 88),
    MockUsageSnapshot(provider: UsageProvider.antigravity, percent: 55),
  ];

  static MockUsageSnapshot forProvider(UsageProvider provider) {
    return snapshots.firstWhere((snapshot) => snapshot.provider == provider);
  }

  static List<MockUsageSnapshot> enabledSnapshots(
    Set<UsageProvider> enabled,
  ) {
    return [
      for (final snapshot in snapshots)
        if (snapshot.provider != null && enabled.contains(snapshot.provider))
          snapshot,
    ];
  }

  static int nextIndex(int index, int length) {
    if (length <= 0) {
      return 0;
    }
    return (index + 1) % length;
  }

  static MockUsageSnapshot at(int index, {Set<UsageProvider>? enabled}) {
    final pool = enabled == null
        ? snapshots
        : enabledSnapshots(enabled);
    if (pool.isEmpty) {
      return MockUsageSnapshot.empty;
    }
    return pool[index % pool.length];
  }
}
