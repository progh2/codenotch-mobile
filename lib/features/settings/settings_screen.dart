import 'package:flutter/material.dart';

import '../../core/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text(AppInfo.name),
            subtitle: Text('Mock ring UI — version 0.0.1+1'),
          ),
          ListTile(
            leading: Icon(Icons.widgets_outlined),
            title: Text('Home widgets'),
            subtitle: Text(
              'Android and iOS widgets show a mock mint ring, percent, and '
              'short label. Refresh in the app (or tap the Android widget) '
              'to cycle mock values.',
            ),
          ),
          ListTile(
            leading: Icon(Icons.sync_disabled_outlined),
            title: Text('Usage sync'),
            subtitle: Text(
              'Out of scope: no PC credential files, no live provider APIs yet.',
            ),
          ),
        ],
      ),
    );
  }
}
