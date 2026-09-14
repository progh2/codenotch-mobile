import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/app.dart';
import 'package:codenotch_mobile/core/constants.dart';
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
  });

  testWidgets('refresh mock cycles percent and label', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Mock usage'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('41%'), findsOneWidget);
    expect(find.text('Sample quota'), findsOneWidget);
    expect(find.text('72%'), findsNothing);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('88%'), findsOneWidget);
    expect(find.text('Demo ring'), findsOneWidget);

    await tester.tap(find.text('Refresh mock'));
    await tester.pump();

    expect(find.text('72%'), findsOneWidget);
    expect(find.text('Mock usage'), findsOneWidget);
  });

  testWidgets('settings route opens mock-widget copy', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Usage sync'), findsOneWidget);
    expect(
      find.text(
        'Out of scope: no PC credential files, no live provider APIs yet.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('mock mint ring'), findsOneWidget);
  });
}
