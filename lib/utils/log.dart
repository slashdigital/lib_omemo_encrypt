// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:flutter/foundation.dart';

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
      if (kDebugMode) {
        print('D/[$tag]: $message');
      }
      log('D/[$tag]: $message');
    }
  }

  void i(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.INFO.index) {
      if (kDebugMode) {
        print('I/[$tag]: $message');
      }
      log('I/[$tag]: $message');
    }
  }

  void w(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.WARNING.index) {
      if (kDebugMode) {
        print('W/[$tag]: $message');
      }
      log('W/[$tag]: $message');
    }
  }

  void e(String tag, dynamic message) {
    if (logLevel.index <= LogLevel.ERROR.index) {
      if (kDebugMode) {
        print('E/[$tag]: $message');
      }
      log('E/[$tag]: $message');
    }
  }
}

enum LogLevel { VERBOSE, DEBUG, INFO, WARNING, ERROR, OFF }
