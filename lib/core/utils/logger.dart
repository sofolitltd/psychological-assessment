import 'dart:developer' as dev;

enum LogLevel { info, warning, error }

class AppLogger {
  final String tag;

  const AppLogger(this.tag);

  void info(String message) => _log(LogLevel.info, message);
  void warning(String message) => _log(LogLevel.warning, message);
  void error(String message, [Object? exception, StackTrace? stack]) =>
      _log(LogLevel.error, message, exception, stack);

  void _log(LogLevel level, String message, [Object? exception, StackTrace? stack]) {
    final prefix = switch (level) {
      LogLevel.info => '[INFO]',
      LogLevel.warning => '[WARN]',
      LogLevel.error => '[ERROR]',
    };
    dev.log(
      '$prefix [$tag] $message',
      time: DateTime.now(),
      error: exception,
      stackTrace: stack,
    );
  }
}
