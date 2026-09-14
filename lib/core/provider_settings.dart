import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_widget_sync.dart';
import 'mock_usage.dart';
import 'usage_providers.dart';

/// Persists which providers appear on the widget and in-app preview.
abstract class ProviderSettingsStore {
  Future<Set<UsageProvider>?> loadEnabled();

  Future<void> saveEnabled(Set<UsageProvider> enabled);
}

/// [SharedPreferences] backing store. Missing keys mean "all enabled".
class SharedPreferencesProviderSettingsStore implements ProviderSettingsStore {
  SharedPreferencesProviderSettingsStore({this._prefs});

  static const enabledKey = 'enabled_providers';

  SharedPreferences? _prefs;

  Future<SharedPreferences> _instance() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<Set<UsageProvider>?> loadEnabled() async {
    final prefs = await _instance();
    final ids = prefs.getStringList(enabledKey);
    if (ids == null) {
      return null;
    }
    return {
      for (final id in ids) ?UsageProvider.fromId(id),
    };
  }

  @override
  Future<void> saveEnabled(Set<UsageProvider> enabled) async {
    final prefs = await _instance();
    await prefs.setStringList(
      enabledKey,
      [for (final provider in UsageProvider.all) if (enabled.contains(provider)) provider.id],
    );
  }
}

/// In-memory store for widget tests (avoids the SharedPreferences plugin).
class MemoryProviderSettingsStore implements ProviderSettingsStore {
  MemoryProviderSettingsStore({Set<UsageProvider>? initialEnabled})
      : _enabled = initialEnabled == null ? null : {...initialEnabled};

  Set<UsageProvider>? _enabled;

  @override
  Future<Set<UsageProvider>?> loadEnabled() async =>
      _enabled == null ? null : {..._enabled!};

  @override
  Future<void> saveEnabled(Set<UsageProvider> enabled) async {
    _enabled = {...enabled};
  }
}

/// Holds the enabled provider set and the current mock snapshot index.
class ProviderSettingsController extends ChangeNotifier {
  ProviderSettingsController({
    ProviderSettingsStore? store,
    Set<UsageProvider>? enabled,
    this.syncWidget = syncMockHomeWidget,
  })  : store = store ?? MemoryProviderSettingsStore(),
        _enabled = {...(enabled ?? UsageProvider.all)};

  final ProviderSettingsStore store;
  final Future<void> Function({
    required MockUsageSnapshot snapshot,
    required int index,
    required Set<UsageProvider> enabled,
  }) syncWidget;

  Set<UsageProvider> _enabled;
  int _index = 0;

  Set<UsageProvider> get enabled => Set.unmodifiable(_enabled);

  int get index => _index;

  bool isEnabled(UsageProvider provider) => _enabled.contains(provider);

  List<MockUsageSnapshot> get visibleSnapshots =>
      MockUsageCatalog.enabledSnapshots(_enabled);

  MockUsageSnapshot get currentSnapshot =>
      MockUsageCatalog.at(_index, enabled: _enabled);

  Future<void> load() async {
    final loaded = await store.loadEnabled();
    if (loaded != null) {
      _enabled = {...loaded};
    }
    _clampIndex();
    notifyListeners();
  }

  Future<void> setEnabled(UsageProvider provider, bool value) async {
    if (value) {
      _enabled.add(provider);
    } else {
      _enabled.remove(provider);
    }
    _clampIndex();
    notifyListeners();
    await store.saveEnabled(_enabled);
    await persistToWidget();
  }

  Future<void> cycle() async {
    final pool = visibleSnapshots;
    if (pool.isEmpty) {
      return;
    }
    _index = MockUsageCatalog.nextIndex(_index, pool.length);
    notifyListeners();
    await persistToWidget();
  }

  Future<void> persistToWidget() {
    return syncWidget(
      snapshot: currentSnapshot,
      index: _index,
      enabled: _enabled,
    );
  }

  void _clampIndex() {
    final length = visibleSnapshots.length;
    if (length == 0) {
      _index = 0;
      return;
    }
    _index = _index % length;
  }
}
