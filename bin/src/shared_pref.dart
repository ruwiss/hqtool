import 'dart:io';

import 'models/compressed_shared.dart';
import 'utils/extensions/datetime_extensions.dart';
import 'package:path/path.dart' as p;

class SharedPref {
  SharedPref._private();

  static final SharedPref _instance = SharedPref._private();

  static SharedPref get instance => _instance;

  File get _lastCompressedFile =>
      File(p.join(Directory.current.path, 'output', '.compressed'));

  void writeCompressed(String compressedContent,
      {String? videoTitle, required String language}) async {
    final compressed = CompressedShared(
      compressed: compressedContent,
      videoTitle: videoTitle,
      language: language,
      date: DateTime.now().monthDaySuffixYear,
    );

    await _lastCompressedFile.writeAsString(compressed.toJsonString());
  }

  CompressedShared? getLastCompressed() {
    if (!_lastCompressedFile.existsSync()) return null;
    final compressed = _lastCompressedFile.readAsStringSync();
    return CompressedShared.fromJsonString(compressed);
  }
}
