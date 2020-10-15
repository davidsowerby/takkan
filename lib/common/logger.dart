import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// [SimplePrinter] causes web page to freeze
Logger getLogger(Type type) {
  if (kIsWeb) {
    return Logger(
        printer: LogfmtPrinter(),
        output: WebConsoleOutput(),
        filter: WebDebugFilter());
  } else {
    return Logger(printer: PrettyPrinter(), output: ConsoleOutput());
  }

//  return Logger(printer: PrettyPrinter(),output: (kIsWeb) ? WebConsoleOutput() : ConsoleOutput());
}

/// assert statements in the standard [DebugFilter] seem to get confused when running on Web
class WebDebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = (event.level.index >= level.index);
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
