import 'package:logger/logger.dart';

//class Logger {
//  bool printToConsole = false;
//
//  void info(String message) {
//    final className = Trace.current().frames[1].member.split(".")[0];
//    final methodName = Trace.current().frames[1].member.split(".")[1];
//    if (printToConsole) debugPrint(message);
//    FlutterBugfender.l(message,
//        logLevel: LogLevel.Info,
//        tag: className,
//        methodName: methodName,
//        className: className);
//  }
//
//  void error(String message) {
//    final className = Trace.current().frames[1].member.split(".")[0];
//    final methodName = Trace.current().frames[1].member.split(".")[1];
//    if (printToConsole) debugPrint(message);
//    FlutterBugfender.l(message,
//        logLevel: LogLevel.Error,
//        tag: className,
//        methodName: methodName,
//        className: className);
//    FlutterBugfender.forceSendOnce();
//  }
//
//  void errorException(Object e, [StackTrace s]) {
//    if (printToConsole) print(e);
//    if (printToConsole && s != null) print(s);
//
//    FlutterBugfender.error('Exception: $e.\nStacktrace: $s');
//    FlutterBugfender.forceSendOnce();
//  }
//
//  void warn(String message) {
//    final className = Trace.current().frames[1].member.split(".")[0];
//    final methodName = Trace.current().frames[1].member.split(".")[1];
//    if (printToConsole) debugPrint(message);
//    FlutterBugfender.l(message,
//        logLevel: LogLevel.Warning,
//        tag: className,
//        methodName: methodName,
//        className: className);
//    FlutterBugfender.forceSendOnce();
//  }
//
//  void setDeviceString(String key, String userId) {
//    FlutterBugfender.setDeviceString(key, userId);
//  }
//}


var logger = Logger(
  printer: PrefixPrinter(PrettyPrinter(
      methodCount: 1,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 180,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp,

  )),
  output: null, // Use the default LogOutput (-> send everything to console)
  filter: null, // Use the default LogFilter (-> only log in debug mode)
);
