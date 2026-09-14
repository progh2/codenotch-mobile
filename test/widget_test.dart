import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/app.dart';
import 'package:codenotch_mobile/core/constants.dart';
import 'package:codenotch_mobile/core/provider_settings.dart';
import 'package:codenotch_mobile/core/usage_providers.dart';
import 'package:codenotch_mobile/features/home/home_screen.dart';
import 'package:codenotch_mobile/features/home/usage_ring.dart';

void main() {
  testWidgets('home screen identifies Codenotch Mobile', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.text('Codenotch Mobile'), findsWidgets);
    expect(find.text('Home-screen companion for AI usage'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Android App Widget'), 200);
    expect(find.text('Android App Widget'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('iOS WidgetKit'), 200);
    expect(find.text('iOS WidgetKit'), findsOneWidget);
  });

  testWidgets('home screen shows mock ring preview', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.byType(HomeWidgetPreviewCard), findsOneWidget);
    expect(find.byType(UsageRing), findsOneWidget);
    expect(find.text(HomeWidgetPlaceholder.usage), findsOneWidget);
    expect(find.text(HomeWidgetPlaceholder.label), findsOneWidget);
    expect(find.text('Home-screen widgets'), findsOneWidget);
    expect(find.text('Refresh mock'), findsOneWidget);
    expect(
      find.text('Showing Claude · Cursor · Codex · Antigravity'),
      findsOneWidget,
    );
  });

  testWidgets('refresh mock cycles enabled provider rings', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Claude'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('41%'), findsOneWidget);
    expect(find.text('Cursor'), findsOneWidget);
    expect(find.text('72%'), findsNothing);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('88%'), findsOneWidget);
    expect(find.text('Codex'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('55%'), findsOneWidget);
    expect(find.text('Antigravity'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Claude'), findsOneWidget);
  });

  testWidgets('settings route opens provider toggles', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Providers on widget'), findsOneWidget);
    expect(find.text('Claude'), findsOneWidget);
    expect(find.text('Cursor'), findsOneWidget);
    expect(find.text('Codex'), findsOneWidget);
    expect(find.text('Antigravity'), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(4));
    expect(find.text('Usage sync'), findsOneWidget);
    expect(
      find.text(
        'Out of scope: no PC credential files, no live provider APIs yet.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('disabling a provider hides it from preview and cycle', (
    tester,
  ) async {
    final settings = ProviderSettingsController(
      syncWidget: ({snapshot, index, enabled}) async {},
    );
    await tester.pumpWidget(CodenotchApp(settings: settings));

    expect(find.text('Claude'), findsOneWidget);
    expect(find.text('72%'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('provider-toggle-claude')));
    await tester.pump();

    expect(settings.isEnabled(UsageProvider.claude), isFalse);
    expect(settings.isEnabled(UsageProvider.cursor), isTrue);

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Claude'), findsNothing);
    expect(find.text('72%'), findsNothing);
    expect(find.text('Cursor'), findsOneWidget);
    expect(find.text('41%'), findsOneWidget);
    expect(find.text('Showing Cursor · Codex · Antigravity'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();
    expect(find.text('Codex'), findsOneWidget);
    expect(find.text('88%'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();
    expect(find.text('Antigravity'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();
    expect(find.text('Cursor'), findsOneWidget);
    expect(find.text('Claude'), findsNothing);
  });

  testWidgets('all providers off shows empty preview', (tester) async {
    final settings = ProviderSettingsController(
      enabled: {},
      syncWidget: ({snapshot, index, enabled}) async {},
    );
    await tester.pumpWidget(CodenotchApp(settings: settings));

    expect(find.text('No providers'), findsOneWidget);
    expect(find.text('--'), findsOneWidget);
    expect(
      find.text('No providers enabled. Turn some on in Settings.'),
      findsOneWidget,
    );
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });
}
