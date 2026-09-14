import 'package:flutter_test/flutter_test.dart';

import 'package:codenotch_mobile/app.dart';
import 'package:codenotch_mobile/core/constants.dart';
import 'package:codenotch_mobile/features/home/home_screen.dart';

void main() {
  testWidgets('home screen identifies Codenotch Mobile', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.text('Codenotch Mobile'), findsWidgets);
    expect(find.text('Home-screen companion for AI usage'), findsOneWidget);
    expect(find.text('Android App Widget'), findsOneWidget);
    expect(find.text('iOS WidgetKit'), findsOneWidget);
  });

  testWidgets('home screen shows widget placeholder preview', (tester) async {
    await tester.pumpWidget(const CodenotchApp());

    expect(find.byType(HomeWidgetPreviewCard), findsOneWidget);
    expect(find.text(HomeWidgetPlaceholder.title), findsWidgets);
    expect(find.text(HomeWidgetPlaceholder.usage), findsOneWidget);
    expect(find.text('Home-screen widgets'), findsOneWidget);
  });

  testWidgets('settings route opens placeholder', (tester) async {
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
  });
}
