import 'models/transcript.dart';

class DataCompressor {
  DataCompressor._private();

  static final DataCompressor _instance = DataCompressor._private();

  static DataCompressor get instance => _instance;

  final String _srtTimeSplitCharacter = "-->";

  String compressSrtContent(List<String> content) {
    try {
      late Iterable<Duration> durations;
      final List<String> newContents = [];
      for (final line in content) {
        if (line.isEmpty) continue;
        if (int.tryParse(line) != null) continue;

        if (line.contains(_srtTimeSplitCharacter)) {
          final split = line.split(_srtTimeSplitCharacter);
          final Duration startTime = _parseToDuration(split.first.trim());
          final Duration endTime = _parseToDuration(split.last.trim());
          durations = [startTime, endTime];
          continue;
        }

        final String newContent =
            "[${durations.first.inSeconds}]${line.trim()}[${durations.last.inSeconds}]";
        newContents.add(newContent);
      }
      return newContents.join('-');
    } catch (e) {
      rethrow;
    }
  }

  String compressJsonSrtContent(Transcripts transcript) {
    try {
      final List<String> newContents = [];

      for (final item in transcript.items) {
        newContents.add(
            "[${item.first.inSeconds}]${item.content.trim()}[${item.last.inSeconds}]");
      }
      return newContents.join('-');
    } catch (e) {
      rethrow;
    }
  }

  String decompressContent(String content) {
    try {
      final List<String> newContents = [];
      final List<String> contents = content.split('-');

      final RegExp regExp = RegExp(r'\[([^\]]+)\]');

      contents.asMap().forEach((key, value) {
        final Iterable<Duration> durations = regExp.allMatches(value).map((e) {
          return Duration(seconds: int.parse(e.group(1)!));
        });

        final String content = value.replaceAll(regExp, "");

        newContents.addAll([
          "${key + 1}",
          "${_durationToString(durations.first)} $_srtTimeSplitCharacter ${_durationToString(durations.last)}",
          content,
          "",
        ]);
      });

      return newContents.join('\n');
    } catch (e) {
      rethrow;
    }
  }

  Duration _parseToDuration(String time) {
    try {
      time = time.replaceAll(',', '.');

      return Duration(
        hours: int.parse(time.split(':')[0]),
        minutes: int.parse(time.split(':')[1]),
        seconds: int.parse(time.split(':')[2].split('.')[0]),
        milliseconds: int.parse(time.split(':')[2].split('.')[1]),
      );
    } catch (e) {
      rethrow;
    }
  }

  String _durationToString(Duration duration) {
    try {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      String hours = twoDigits(duration.inHours);
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      String seconds = twoDigits(duration.inSeconds.remainder(60));

      String milliseconds =
          duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0');

      return "$hours:$minutes:$seconds,$milliseconds";
    } catch (e) {
      rethrow;
    }
  }
}
