class FileNotFound implements Exception {
  final String filePath;

  FileNotFound(this.filePath);

  @override
  String toString() {
    return "Dosya bulunamadı: $filePath";
  }
}
