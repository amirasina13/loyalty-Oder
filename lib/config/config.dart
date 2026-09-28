// lib/config/config.dart

import 'environment.dart';

const String flavor = String.fromEnvironment('flavor');

class AppConfig {
  static late final String apiUrl;
  static late final String apiUsername;
  static late final String apiPassword;
  static late final String applink;

  static void initialize() {
    // Fail fast if flavor is missing or invalid
    if (flavor != 'staging' && flavor != 'production') {
      throw StateError(
        'CRITICAL: Missing or invalid flavor. You must build with '
        '--dart-define=flavor=staging OR --dart-define=flavor=production. '
        'Received: "$flavor"',
      );
    }

    final Map<String, dynamic> env =
        (flavor == 'staging') ? staging : production;

    // Use the values from the selected map
    apiUrl = env['apiUrl'];
    apiUsername = env['apiUsername'];
    apiPassword = env['apiPassword'];
    applink = env['applink'];
  }

  static const String apiVersionDefault = '/api/v4';
}
