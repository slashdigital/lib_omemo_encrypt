import 'dart:developer';

class Log {
  static LogLevel logLevel = LogLevel.VERBOSE;

  static bool logXmpp = true;

  static void v(String tag, String message) {
    if (logLevel.index <= LogLevel.VERBOSE.index) {
      log('V/[$tag]: $message');
    }
  }

  static void d(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.DEBUG.index) {
      print('D/[$tag]: $message');
      log('D/[$tag]: $message');
    }
  }

  static void i(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.INFO.index) {
      print('D/[$tag]: $message');
      log('I/[$tag]: $message');
    }
  }

  static void w(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.WARNING.index) {
      log('W/[$tag]: $message');
    }
  }

  static void e(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.ERROR.index) {
      log('E/[$tag]: $message');
    }
  }
}

enum LogLevel { VERBOSE, DEBUG, INFO, WARNING, ERROR, OFF }
