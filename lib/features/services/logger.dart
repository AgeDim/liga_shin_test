import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logger/logger.dart';

class CustomLogger {
  static final Logger _logger = Logger();

  static void verbose(String message) {
    if (kDebugMode) {
      _logger.v(message);
    }
  }

  static void debug(String message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  static void info(dynamic message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  static void error(dynamic message) {
    if (kDebugMode) {
      _logger.e(message);
    }
  }

  static void wtf(String message) {
    if (kDebugMode) {
      _logger.wtf(message);
    }
  }
}