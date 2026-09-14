/// One mock usage frame written to native widgets and the in-app preview.
class MockUsageSnapshot {
  const MockUsageSnapshot({
    required this.percent,
    required this.label,
  });

  final int percent;
  final String label;

  String get percentText => '$percent%';

  double get progress => (percent.clamp(0, 100)) / 100;
}

/// Cycling mock catalog. No live provider APIs.
abstract final class MockUsageCatalog {
  static const initial = MockUsageSnapshot(percent: 72, label: 'Mock usage');

  static const snapshots = [
    initial,
    MockUsageSnapshot(percent: 41, label: 'Sample quota'),
    MockUsageSnapshot(percent: 88, label: 'Demo ring'),
  ];

  static int nextIndex(int index) => (index + 1) % snapshots.length;

  static MockUsageSnapshot at(int index) =>
      snapshots[index % snapshots.length];
}
