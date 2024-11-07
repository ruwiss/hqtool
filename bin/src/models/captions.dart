final class Captions {
  final List<CaptionTrack> items;

  Captions(this.items);

  factory Captions.fromMap(Map<String, dynamic> map) {
    final List captionTracks = map['captionTracks'];
    return Captions(
      captionTracks.map((e) => CaptionTrack.fromMap(e)).toList(),
    );
  }
}

final class CaptionTrack {
  final String captionUrl;
  final String captionName;
  final String langCode;

  CaptionTrack(this.captionUrl, this.captionName, this.langCode);

  factory CaptionTrack.fromMap(Map<String, dynamic> map) {
    return CaptionTrack(
      map['baseUrl'] as String,
      map['name']['simpleText'] as String,
      map['languageCode'] as String,
    );
  }
}
