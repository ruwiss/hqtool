import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'src/data_compressor.dart';
import 'src/file_service.dart';
import 'src/utils/environment.dart';
import 'src/youtube_transcript_scrapper.dart';
import 'package:interact/interact.dart';
import 'src/utils/extensions/string_extensions.dart';
import 'src/utils/language_codes.dart';
import 'src/generative_ai.dart';
import 'src/shared_pref.dart';

Future<void> init() async {
  await initializeDateFormatting("tr");
  if (!await Environment.init()) {
    _getApiKeyFromUser();
  }
}

void _getApiKeyFromUser() {
  while (!Environment.isContainsKey("API_KEY")) {
    final apiKey = Input(
      prompt: "Gemini API anahtarınızı giriniz. (https://aistudio.google.com/)",
      validator: (v) {
        if (RegExp(r"AIza[0-9A-Za-z_-]{35}").hasMatch(v)) {
          return true;
        } else {
          throw ValidationError('API Key geçersiz');
        }
      },
    ).interact();

    final model = Input(
      prompt: "Hangi modeli kullanacaksınız?",
      defaultValue: "gemini-1.5-flash-latest",
    ).interact();

    Environment.setApiKeyAndModel(apiKey, model);
  }
}

void printUsage(ArgParser argParser) {
  final String fileName = FileService.instance.getPlatformFileName();
  stdout.writeln('Kullanım: $fileName <flags> [arguments]');
  stdout.writeln(argParser.usage);
}

void main(List<String> arguments) async {
  try {
    await init();
    final processList = [
      "Yapay Zeka ile Altyazı Çevirisi",
      "Youtube Videosundan Altyazı İndir",
      "Yapay Zeka ile Altyazıyı Konuşma Metnine Dönüştür"
    ];

    final int processSelect =
        Select(prompt: "Ne yapmak istersiniz?", options: processList)
            .interact();

    switch (processSelect) {
      // Yapay Zeka ile Altyazı Çevirisi
      case 0:
        await _selectTranslateSrt();
        break;
      // Youtube Videosundan Altyazı İndir
      case 1:
        await _youtubeToSrt();
        break;
      // Yapay Zeka ile Altyazıyı Konuşma Metnine Dönüştür
      case 2:
        await _selectSpeechTextGenerator();
        break;
      default:
        break;
    }
  } catch (e) {
    log(e.toString());
    stdout.writeln(e);
  }
}

Future<void> _selectTranslateSrt() async {
  try {
    final fetchChoice = ['Youtube videosundan', '.SRT dosyasından'];
    final int selection = Select(
            prompt: "Hangi yöntemle dönüştürme yapmak istiyorsunuz?",
            options: fetchChoice)
        .interact();

    final String compressedTranscriptString =
        selection == 0 ? await _youtubeToSrt() : await _srtToSrt();

    final String language = _getLanguageCodeFromUser();

    stdout.writeln("Yapay zeka altyazınızı hazırlıyor..");

    final result = await GenerativeAi.translateSrtContent(
        srtContent: compressedTranscriptString,
        language: language,
        videoTitle: YouTubeTranscriptScrapper().youtubeVideoTitle);

    SharedPref.instance.writeCompressed(
      result.srt,
      language: language,
      videoTitle: YouTubeTranscriptScrapper().youtubeVideoTitle,
    );

    final decompressedSrtContent =
        DataCompressor.instance.decompressContent(result.srt);

    final outputPath = await FileService.instance
        .writeFile(content: decompressedSrtContent, fileName: "output.srt");

    FileService.instance
        .writeFile(content: result.summary, fileName: "summary.txt");

    stdout.writeln("");
    stdout.writeln("Output: $outputPath");
    stdout.writeln("");
    stdout.writeln("İşte yazılan altyazının özeti:");
    stdout.writeln(result.summary);
  } catch (e) {
    rethrow;
  }
}

Future<void> _selectSpeechTextGenerator() async {
  final lastCompressed = SharedPref.instance.getLastCompressed();
  bool isLastCompressedEmpty = lastCompressed == null;
  final options = [
    "SRT Dosyasından",
    "YouTube Videosundan",
  ];
  if (!isLastCompressedEmpty) {
    options.add(
        "Son Altyazı ile (${lastCompressed.videoTitle}) Dil: ${lastCompressed.language} Tarih: ${lastCompressed.date}");
  }

  final int selection = Select(
          prompt: "Hangi yöntemle dönüştürme yapmak istiyorsunuz?",
          options: options)
      .interact();

  late final String compressedContent;
  if (selection == 0) {
    compressedContent = await _srtToSrt();
  } else if (selection == 1) {
    compressedContent = await _youtubeToSrt();
  } else if (selection == 2) {
    compressedContent = lastCompressed!.compressed;
  }

  final language = _getLanguageCodeFromUser(
      promptText: "Hazırlanacak konuşma metninin dil kodunuz yazınız.");

  final responseText = await GenerativeAi.generateSpeechText(
      compressedContent: compressedContent, language: language);

  final outputPath = await FileService.instance.writeFile(
    content: responseText,
    title: lastCompressed?.videoTitle,
    fileName: 'speechText.md',
  );

  stdout.writeln("Output: $outputPath");
}

Future<String> _youtubeToSrt() async {
  final youtubeUrl = Input(
    prompt: 'Youtube video linkini giriniz:',
    validator: (t) {
      if (t.isYoutubeUrl()) {
        return true;
      } else {
        throw ValidationError('Doğru bir YouTube linki giriniz.');
      }
    },
  ).interact();
  await YouTubeTranscriptScrapper().fetchYoutubeData(youtubeUrl);
  stdout.writeln(YouTubeTranscriptScrapper().youtubeVideoTitle);

  final selectedCaptionTrackIndex = Select(
          prompt: "Videodan alınacak dil dosyasını seçiniz:",
          options: YouTubeTranscriptScrapper()
              .captionItems
              .map((e) => "${e.langCode} ${e.captionName}".trim())
              .toList())
      .interact();

  final selectedCaptionTrack =
      YouTubeTranscriptScrapper().captionItems[selectedCaptionTrackIndex];

  final transcript = await YouTubeTranscriptScrapper()
      .getTranscriptsByTranscriptUrl(selectedCaptionTrack.captionUrl);

  final compressed = DataCompressor.instance.compressJsonSrtContent(transcript);

  FileService.instance
      .writeFile(
        content: DataCompressor.instance.decompressContent(compressed),
        fileName: "downloaded.srt",
      )
      .then((v) => stdout.writeln("SRT Dosyası indirildi: $v"));

  return compressed;
}

Future<String> _srtToSrt() async {
  final srtFilePath = Input(
      prompt: '.SRT dosyanızın yolunu giriniz.',
      validator: (t) {
        if (File(t).existsSync()) {
          return true;
        } else {
          throw ValidationError('Dosya bulunamadı.');
        }
      }).interact();

  final List<String> srtFileLines =
      await FileService.instance.readLinesSrtFile(srtFilePath);
  return DataCompressor.instance.compressSrtContent(srtFileLines);
}

String _getLanguageCodeFromUser({String? promptText}) {
  int selectedLangConfirm = 0;
  late String selectedLanguageCode;
  while (selectedLangConfirm != 1) {
    selectedLanguageCode = Input(
      prompt:
          '${promptText ?? 'Lütfen çevirmek istediğiniz dil kodunu giriniz'} ("tr", "en", "de", "de-at" gibi)',
      validator: (v) {
        if (languageCodes.containsKey(v.trim().toLowerCase())) {
          return true;
        } else {
          throw ValidationError('Doğru bir dil kodu giriniz.');
        }
      },
    ).interact();

    final selected = languageCodes[selectedLanguageCode.toLowerCase().trim()];
    if (selected == null) continue;

    selectedLangConfirm = Select(
        prompt: "$selected olarak çevirmek istiyor musunuz?",
        options: ["Hayır", "Evet"]).interact();
  }
  return selectedLanguageCode;
}
