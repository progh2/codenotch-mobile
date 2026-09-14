import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/provider_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = ProviderSettingsController(
    store: SharedPreferencesProviderSettingsStore(),
  );
  await settings.load();
  await settings.persistToWidget();
  runApp(CodenotchApp(settings: settings));
}
