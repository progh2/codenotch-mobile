import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/home_widget_sync.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await syncMockHomeWidget();
  runApp(const CodenotchApp());
}
