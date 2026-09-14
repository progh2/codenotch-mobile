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
            'Companion to Codenotch for Windows. Home-screen widgets are '
            'placeholder shells (Android App Widget + iOS WidgetKit). Live '
            'usage sync is not included yet.',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          Text('Home-screen widgets', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          const HomeWidgetPreviewCard(),
          const SizedBox(height: 12),
          const _PlaceholderCard(
            icon: Icons.android,
            title: 'Android App Widget',
            subtitle:
                'Add Codenotch from the home-screen widget picker. Shows '
                '${HomeWidgetPlaceholder.title} / ${HomeWidgetPlaceholder.usage}.',
          ),
          const SizedBox(height: 12),
          const _PlaceholderCard(
            icon: Icons.phone_iphone,
            title: 'iOS WidgetKit',
            subtitle:
                'Add Codenotch after a Mac / simulator build. Kind: '
                '${HomeWidgetIds.ios}.',
          ),
        ],
      ),
    );
  }
}

/// In-app preview that matches the native dark placeholder widget.
class HomeWidgetPreviewCard extends StatelessWidget {
  const HomeWidgetPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Home widget preview ${HomeWidgetPlaceholder.title} '
          '${HomeWidgetPlaceholder.usage}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                HomeWidgetPlaceholder.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                HomeWidgetPlaceholder.usage,
                style: TextStyle(
                  color: Color(0xFFE8C07A),
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
