

import 'package:flutter/services.dart';

class FileOpener {
  static const MethodChannel _channel = const MethodChannel('openFileChannel');

  static Future<String> open(filePath) async {
    final Map<String, dynamic> args = <String, dynamic>{'path': filePath};
    _channel.invokeMethod('openFile', args);
  }
}