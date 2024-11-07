import 'exceptions/file_not_found.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'youtube_transcript_scrapper.dart';
import 'utils/extensions/string_extensions.dart';

class FileService {
  FileService._private();

  static final FileService _instance = FileService._private();

  static FileService get instance => _instance;

  String getPlatformFileName() {
    final String scriptPath = Platform.script.toFilePath();
    final String fileName = scriptPath.split(Platform.pathSeparator).last;
    return fileName;
  }

  Future<List<String>> readLinesSrtFile(String filePath) {
    final completer = Completer<List<String>>();

    final File file = File(filePath);
    if (!file.existsSync()) {
      completer.completeError(FileNotFound(filePath));
    } else {
      final content = file.readAsLinesSync();
      completer.complete(content);
    }
    return completer.future;
  }

  String _outputPath(String fileName, {String? title}) {
    final String? formattedTitle =
        YouTubeTranscriptScrapper().youtubeVideoTitle?.onlyLatin ??
            title?.onlyLatin;

    if (formattedTitle == null) {
      return p.join(Directory.current.path, "output", fileName);
    } else {
      return p.join(Directory.current.path, "output", formattedTitle, fileName);
    }
  }

  Future<String> writeFile(
      {required String content,
      required String fileName,
      String? title,
      bool isHidden = false}) async {
    try {
      final File file = File(_outputPath(fileName, title: title));
      await file.create(recursive: true);
      await file.writeAsString(content);
      if (isHidden) {
        await Process.run('attrib', ['+h', file.path]);
      }
      return file.path;
    } catch (e) {
      rethrow;
    }
  }
}
