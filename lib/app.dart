import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/settings/settings_screen.dart';

class CodenotchApp extends StatelessWidget {
  const CodenotchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
