import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

Logger logType(Type type) {
  return logName(type.toString());
}

/// [SimplePrinter] causes web page to freeze
Logger logName(String source) {
  if (kIsWeb) {
    return Logger(printer: LogfmtPrinter(), output: WebConsoleOutput(), filter: WebDebugFilter());
  } else {
    return Logger(printer: PrettyPrinter(), output: ConsoleOutput());
  }
  //  return Logger(printer: PrettyPrinter(),output: (kIsWeb) ? WebConsoleOutput() : ConsoleOutput());
}

/// assert statements in the standard [DebugFilter] seem to get confused when running on Web
class WebDebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    Level reqLevel = level ?? Level.debug;
    var shouldLog = (event.level.index >= reqLevel.index);
    return shouldLog;
  }
}

/// Sends everything to the system console.
class WebConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final message = event.lines.join("\n");
    print(message);
  }
}

