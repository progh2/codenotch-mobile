import 'package:flutter/material.dart';

import 'core/provider_settings.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/settings/settings_screen.dart';

class CodenotchApp extends StatefulWidget {
  const CodenotchApp({super.key, this.settings});

  /// Production [main] passes a loaded controller. Tests omit it and get an
  /// in-memory store with every provider enabled.
  final ProviderSettingsController? settings;

  @override
  State<CodenotchApp> createState() => _CodenotchAppState();
}

class _CodenotchAppState extends State<CodenotchApp> {
  late final ProviderSettingsController _settings =
      widget.settings ?? ProviderSettingsController();

  @override
  void dispose() {
    if (widget.settings == null) {
      _settings.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderSettingsScope(
      notifier: _settings,
      child: MaterialApp(
        title: 'Codenotch Mobile',
        debugShowCheckedModeBanner: false,
        theme: CodenotchTheme.light(),
        darkTheme: CodenotchTheme.dark(),
        themeMode: ThemeMode.system,
        routes: {
          HomeScreen.routeName: (_) => const HomeScreen(),
          SettingsScreen.routeName: (_) => const SettingsScreen(),
        },
        initialRoute: HomeScreen.routeName,
      ),
    );
  }
}

class ProviderSettingsScope extends InheritedNotifier<ProviderSettingsController> {
  const ProviderSettingsScope({
    super.key,
    required ProviderSettingsController super.notifier,
    required super.child,
  });

  static ProviderSettingsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProviderSettingsScope>();
    assert(scope != null, 'ProviderSettingsScope not found');
    return scope!.notifier!;
  }
}
