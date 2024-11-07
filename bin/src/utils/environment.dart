import 'package:path/path.dart' as p;
import 'dart:convert';
import 'dart:io';

final class Environment {
  static Map<String, dynamic> _envData = {};

  static File get _envFile => File(p.join(Directory.current.path, 'env.json'));

  static Future<bool> init() async {
    if (!_envFile.existsSync()) {
      return false;
    }
    _envData = jsonDecode(await _envFile.readAsString());
    return true;
  }

  static String get(String key) => _envData[key];

  static bool isContainsKey(String key) => _envData.containsKey(key);

  static void setApiKeyAndModel(String apiKey, String model) {
    _envData = {"API_KEY": apiKey, "MODEL": model};
    _envFile.writeAsStringSync(jsonEncode(_envData));
  }
}
