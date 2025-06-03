/// lib/constants.dart

/// On an Android emulator, 10.0.2.2 points to the host’s localhost.
/// We set the default here so you don’t have to remember --dart-define every time.
const String kApiBase =
    String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:8000/api');
