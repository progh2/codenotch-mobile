import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppInfo.name),
        actions: [
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Text(AppInfo.name, style: textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            AppInfo.tagline,
            style: textTheme.titleMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Companion to Codenotch for Windows. This app will host home-screen '
            'usage widgets (Android App Widget + iOS WidgetKit). Live usage sync '
            'is not included yet.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          Text('Upcoming widgets', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          const _PlaceholderCard(
            icon: Icons.android,
            title: 'Android App Widget',
            subtitle:
                'Empty shell lands in issue #2 (${HomeWidgetIds.android}).',
          ),
          const SizedBox(height: 12),
          const _PlaceholderCard(
            icon: Icons.phone_iphone,
            title: 'iOS WidgetKit',
            subtitle: 'Empty shell lands in issue #3 (${HomeWidgetIds.ios}).',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
