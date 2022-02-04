// ignore_for_file: constant_identifier_names

import 'dart:developer';

class Log {
  static Log? _instane;

  static Log get instance {
    _instane ??= Log();
    return _instane!;
  }

  LogLevel logLevel = LogLevel.VERBOSE;

  void v(String tag, String message) {
    if (logLevel.index <= LogLevel.VERBOSE.index) {
      log('V/[$tag]: $message');
    }
  }

  void d(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.DEBUG.index) {
      log('D/[$tag]: $message');
    }
  }

  void i(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.INFO.index) {
      log('I/[$tag]: $message');
    }
  }

  void w(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.WARNING.index) {
      log('W/[$tag]: $message');
    }
  }

  void e(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.ERROR.index) {
      log('E/[$tag]: $message');
    }
  }
}

enum LogLevel { VERBOSE, DEBUG, INFO, WARNING, ERROR, OFF }
