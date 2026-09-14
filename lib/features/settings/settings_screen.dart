import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/constants.dart';
import '../../core/mock_usage.dart';
import '../../core/usage_providers.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final settings = ProviderSettingsScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          return ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(AppInfo.name),
                subtitle: Text('Mock ring UI — version 0.0.1+1'),
              ),
              const ListTile(
                leading: Icon(Icons.widgets_outlined),
                title: Text('Providers on widget'),
                subtitle: Text(
                  'Choose which mock rings appear on the home-screen widget '
                  'and in-app preview. Values stay mock — no live APIs.',
                ),
              ),
              for (final provider in UsageProvider.all)
                SwitchListTile(
                  key: ValueKey('provider-toggle-${provider.id}'),
                  secondary: const Icon(Icons.donut_large_outlined),
                  title: Text(provider.label),
                  subtitle: Text(
                    'Mock ${MockUsageCatalog.forProvider(provider).percentText}',
                  ),
                  value: settings.isEnabled(provider),
                  onChanged: (value) => settings.setEnabled(provider, value),
                ),
              const ListTile(
                leading: Icon(Icons.sync_disabled_outlined),
                title: Text('Usage sync'),
                subtitle: Text(
                  'Out of scope: no PC credential files, no live provider APIs yet.',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
