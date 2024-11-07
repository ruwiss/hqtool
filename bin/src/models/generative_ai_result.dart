final class GenerativeAIResult {
  final String srt;
  final String summary;

  GenerativeAIResult(this.srt, this.summary);

  factory GenerativeAIResult.fromMap(Map<String, dynamic> map) {
    String srt = (map['srt'] as String)
        .trim()
        .replaceAll("[-]", "")
        .replaceAll("--", "-")
        .replaceAll("[[", "[")
        .replaceAll("]]", "]")
        .replaceAllMapped(
          RegExp(r'\[(\D+?)\]'),
          (match) => match.group(1) ?? '',
        );

    if (srt.split("-").first.split("]").last.trim().isEmpty) {
      srt = "[0]$srt";
    }
    srt.replaceAll("[0][0]", "[0]");
    final summary = (map['summary'] as String).trim();
    return GenerativeAIResult(srt, summary);
  }
}
