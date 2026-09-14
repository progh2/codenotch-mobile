import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/constants.dart';
import '../../core/mock_usage.dart';
import '../../core/provider_settings.dart';
import '../../core/usage_providers.dart';
import '../../core/widget_colors.dart';
import '../settings/settings_screen.dart';
import 'usage_ring.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final settings = ProviderSettingsScope.of(context);
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
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          final snapshot = settings.currentSnapshot;
          final visible = settings.visibleSnapshots;

          return ListView(
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
                'Companion to Codenotch for Windows. Home-screen widgets show a '
                'mock mint ring and percent (Android App Widget + iOS WidgetKit). '
                'Live usage APIs are not included yet.',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              Text('Home-screen widgets', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                visible.isEmpty
                    ? 'No providers enabled. Turn some on in Settings.'
                    : 'Showing ${_enabledSummary(settings)}',
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              HomeWidgetPreviewCard(snapshot: snapshot),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: visible.isEmpty ? null : settings.cycle,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh mock'),
              ),
              const SizedBox(height: 16),
              const _InfoCard(
                icon: Icons.android,
                title: 'Android App Widget',
                subtitle:
                    'Add Codenotch from the home-screen widget picker. Tap the '
                    'widget to cycle enabled providers. Ring + percent + label.',
              ),
              const SizedBox(height: 12),
              const _InfoCard(
                icon: Icons.phone_iphone,
                title: 'iOS WidgetKit',
                subtitle:
                    'Add Codenotch after a Mac / simulator build. Kind: '
                    '${HomeWidgetIds.ios}. Refresh from this screen to rewrite '
                    'the mock payload.',
              ),
            ],
          );
        },
      ),
    );
  }
}

String _enabledSummary(ProviderSettingsController settings) {
  final labels = [
    for (final provider in UsageProvider.all)
      if (settings.isEnabled(provider)) provider.label,
  ];
  return labels.join(' · ');
}

/// In-app preview that matches the native dark ring widget.
class HomeWidgetPreviewCard extends StatelessWidget {
  const HomeWidgetPreviewCard({super.key, required this.snapshot});

  final MockUsageSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Home widget preview ${snapshot.percentText} ${snapshot.label}',
      child: Align(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 220),
          child: AspectRatio(
            aspectRatio: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: WidgetColors.background,
                borderRadius: BorderRadius.circular(20),
              ),
              child: UsageRing(snapshot: snapshot),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
