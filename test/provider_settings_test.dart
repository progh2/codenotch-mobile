import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:codenotch_mobile/core/mock_usage.dart';
import 'package:codenotch_mobile/core/provider_settings.dart';
import 'package:codenotch_mobile/core/usage_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('defaults to every provider enabled', () {
    final settings = ProviderSettingsController(
      syncWidget: ({
        required snapshot,
        required index,
        required enabled,
      }) async {},
    );
    expect(settings.enabled, UsageProvider.all.toSet());
    expect(settings.currentSnapshot.label, 'Claude');
    expect(settings.visibleSnapshots.map((s) => s.label), [
      'Claude',
      'Cursor',
      'Codex',
      'Antigravity',
    ]);
  });

  test('SharedPreferences store persists enabled providers', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SharedPreferencesProviderSettingsStore();
    expect(await store.loadEnabled(), isNull);

    await store.saveEnabled({UsageProvider.cursor, UsageProvider.antigravity});
    final loaded = await store.loadEnabled();
    expect(loaded, {UsageProvider.cursor, UsageProvider.antigravity});

    final other = SharedPreferencesProviderSettingsStore();
    expect(await other.loadEnabled(), {UsageProvider.cursor, UsageProvider.antigravity});
  });

  test('controller load restores persisted toggles and clamps index', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesProviderSettingsStore.enabledKey: <String>[
        'codex',
        'antigravity',
      ],
    });
    final settings = ProviderSettingsController(
      store: SharedPreferencesProviderSettingsStore(),
      syncWidget: ({
        required snapshot,
        required index,
        required enabled,
      }) async {},
    );
    await settings.load();

    expect(settings.enabled, {UsageProvider.codex, UsageProvider.antigravity});
    expect(settings.currentSnapshot.label, 'Codex');
    expect(settings.currentSnapshot.percentText, '88%');

    await settings.cycle();
    expect(settings.currentSnapshot.label, 'Antigravity');
    await settings.cycle();
    expect(settings.currentSnapshot.label, 'Codex');
  });

  test('disabling current provider jumps to the next enabled snapshot', () async {
    final synced = <MockUsageSnapshot>[];
    final settings = ProviderSettingsController(
      syncWidget: ({
        required snapshot,
        required index,
        required enabled,
      }) async {
        synced.add(snapshot);
      },
    );

    await settings.setEnabled(UsageProvider.claude, false);
    expect(settings.currentSnapshot.label, 'Cursor');
    expect(synced.last.label, 'Cursor');
    expect(settings.isEnabled(UsageProvider.claude), isFalse);
  });

  test('memory store round-trips an empty enabled set', () async {
    final store = MemoryProviderSettingsStore(
      initialEnabled: {UsageProvider.claude},
    );
    expect(await store.loadEnabled(), {UsageProvider.claude});
    await store.saveEnabled({});
    expect(await store.loadEnabled(), isEmpty);
  });
}
