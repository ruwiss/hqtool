import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'models/generative_ai_result.dart';
import 'utils/environment.dart';

class GenerativeAi {
  static final _generateSrtConfig = GenerationConfig(
    responseMimeType: "application/json",
    responseSchema: Schema.object(nullable: false, properties: {
      "srt": Schema.string(nullable: false),
      "summary": Schema.string(nullable: false),
    }),
  );

  static final _model = GenerativeModel(
    model: Environment.get('MODEL'),
    apiKey: Environment.get('API_KEY'),
  );

  static final String _translateSrtPrompt =
      'Generate a JSON with "srt" and "summary" fields. In "srt," translate the subtitle text to "{LANGUAGE}," keeping patterns like [number] and [start]text[end] intact. Avoid translating technical terms or special words. Fix any nonsensical phrases. In "summary," provide a brief overview. {VIDEO_TITLE}';

  static final String _generateSpeechTextPrompt =
      "This text is a subtitle script. Rewrite it in {LANGUAGE}, using the formal 'you' form for a clear and polished presentation. Remove anything except the dialogue, keep any technical terms in their original form, and correct any nonsensical parts from auto-subtitling to ensure clarity and context.";

  static Future<GenerativeAIResult> translateSrtContent(
      {required String srtContent,
      String? videoTitle,
      required String language}) async {
    final content = [
      Content.text(srtContent),
      Content.text(
        _translateSrtPrompt.replaceAll("{LANGUAGE}", language).replaceAll(
            "{VIDEO_TITLE}",
            videoTitle != null ? " Subject: $videoTitle. " : ""),
      ),
    ];
    try {
      final response = await _model.generateContent(
        content,
        generationConfig: _generateSrtConfig,
      );
      final data = jsonDecode(response.text!);

      return GenerativeAIResult.fromMap(data);
    } catch (e) {
      stdout.writeln(e.toString());
      rethrow;
    }
  }

  static Future<String> generateSpeechText(
      {required String compressedContent, required String language}) async {
    final content = [
      Content.text(
        _generateSpeechTextPrompt.replaceAll("{LANGUAGE}", language),
      ),
      Content.text(compressedContent),
    ];

    try {
      final response = await _model.generateContent(content);
      if (response.text == null) {
        throw Exception('Yapay zeka konuşma metnini oluşturamadı.');
      }
      return response.text!;
    } catch (e) {
      stdout.writeln(e.toString());
      rethrow;
    }
  }
}
