import '../utils/extensions/string_extensions.dart';

final class Transcripts {
  final List<Transcript> items;

  Transcripts(this.items);

  factory Transcripts.fromMap(Map<String, dynamic> map) {
    final List transcripts = map['transcript']['text'];
    return Transcripts(
      transcripts
          .map((e) => Transcript.fromMap(e))
          .where((e) => e.content.isNotEmpty)
          .toList(),
    );
  }
}

final class Transcript {
  final Duration first;
  final Duration last;
  final String content;

  Transcript(this.first, this.last, this.content);

  factory Transcript.fromMap(Map<String, dynamic> map) {
    final int startMs = (double.parse(map['start']) * 1000).toInt();
    final int durMs = (double.parse(map['dur']) * 1000).toInt();

    final first = Duration(milliseconds: startMs);
    final last = Duration(milliseconds: startMs + durMs);

    final String content = (map[r'$t'] ?? '');

    return Transcript(first, last, content.replaceHtmlEntities());
  }
}
