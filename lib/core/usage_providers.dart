/// AI usage providers that can appear on the home widget (mock stage).
enum UsageProvider {
  claude('claude', 'Claude'),
  cursor('cursor', 'Cursor'),
  codex('codex', 'Codex'),
  antigravity('antigravity', 'Antigravity');

  const UsageProvider(this.id, this.label);

  final String id;
  final String label;

  static const all = values;

  static UsageProvider? fromId(String id) {
    for (final provider in values) {
      if (provider.id == id) {
        return provider;
      }
    }
    return null;
  }
}
