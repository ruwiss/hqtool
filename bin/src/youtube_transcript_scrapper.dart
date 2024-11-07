import 'dart:convert';
import 'models/transcript.dart';
import 'package:dio/dio.dart';
import 'package:xml2json/xml2json.dart';
import 'models/youtube_data.dart';
import 'models/captions.dart';

class YouTubeTranscriptScrapper {
  YouTubeTranscriptScrapper._private();

  static final YouTubeTranscriptScrapper _instance =
      YouTubeTranscriptScrapper._private();

  YouTubeTranscriptScrapper.internal();

  factory YouTubeTranscriptScrapper() {
    return _instance;
  }

  final Dio _dio = Dio();

  YouTubeData? _youtubeData;

  YouTubeData get youtubeData => _youtubeData!;
  List<CaptionTrack> get captionItems => _youtubeData!.captions.items;
  String? get youtubeVideoTitle => _youtubeData?.videoTitle;

  Future<bool> fetchYoutubeData(String url) async {
    try {
      final response = await _dio.get(url);
      final String html = response.data;
      final captions = _extractCaptions(html);

      _youtubeData = YouTubeData(
          videoTitle: _extractVideoTitle(html),
          captions: Captions.fromMap(captions));
      return true;
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _extractCaptions(String html) {
    if (html.contains('class="g-recaptcha"')) {
      throw Exception(
          'Fazla istek yaptınız, SRT dosyasını elle yüklemeyi deneyin.');
    }

    if (!html.contains('"playabilityStatus":')) {
      throw Exception('Bu video kullanılabilir değil gibi görünüyor');
    }

    final List<String> splittedHtml = html.split('"captions":');

    late final Map<String, dynamic> captionsJson;

    try {
      captionsJson = jsonDecode(splittedHtml[1]
          .split(',"videoDetails')[0]
          .replaceAll('\n', ''))['playerCaptionsTracklistRenderer'];
      return captionsJson;
    } catch (e) {
      throw Exception('Altyazı bulunamadı');
    }
  }

  String? _extractVideoTitle(String html) {
    final regex = RegExp("<title>(.*?)</title>");
    final match = regex.firstMatch(html);
    return match?.group(1)?.replaceAll(" - YouTube", "");
  }

  Future<Transcripts> getTranscriptsByTranscriptUrl(String url) async {
    try {
      final response = await _dio.get(url,
          options: Options(responseType: ResponseType.bytes));
      final String xmlData = utf8.decode(response.data);

      final myTransformer = Xml2Json();

      myTransformer.parse(xmlData);

      final json = myTransformer.toGData();
      final transcripts = Transcripts.fromMap(jsonDecode(json));

      return transcripts;
    } catch (e) {
      rethrow;
    }
  }
}
