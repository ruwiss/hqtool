// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

final class CompressedShared {
  final String compressed;
  final String? videoTitle;
  final String language;
  final String date;

  CompressedShared({
    required this.compressed,
    this.videoTitle,
    required this.language,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'compressed': compressed,
      'videoTitle': videoTitle,
      'language': language,
      'date': date,
    };
  }

  factory CompressedShared.fromMap(Map<String, dynamic> map) {
    return CompressedShared(
      compressed: map['compressed'] as String,
      videoTitle: map['videoTitle'],
      language: map['language'] as String,
      date: map['date'] as String,
    );
  }

  String toJsonString() => json.encode(toMap());

  factory CompressedShared.fromJsonString(String source) =>
      CompressedShared.fromMap(json.decode(source) as Map<String, dynamic>);
}
