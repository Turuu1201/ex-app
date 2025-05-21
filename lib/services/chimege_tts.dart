import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ChimegeTTS {
  static const String _apiUrl = "https://api.chimege.com/v1.2/synthesize";
  static const String _apiToken =
      "b953876322cf70c56e48a0eda057c800eb45e7cfecfee8fceecf34bbd3e63f53";

  static Future<Uint8List?> synthesize(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'plain/text',
          'Token': _apiToken,
        },
        body: text,
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }
}
