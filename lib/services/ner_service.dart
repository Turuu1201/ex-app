import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getDrugDescription(String drugName) async {
  const apiKey =
      "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"; 
  const url = "https://api.openai.com/v1/chat/completions";

  final response = await http.post(
    Uri.parse(url),
    headers: {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {
          "role": "user",
          "content":
              "Эмийн нэр: $drugName\nЭнэ эмийг юунд хэрэглэдэг, яаж хэрэглэх, анхааруулга зэргийг товч бөгөөд ойлгомжтой монгол хэл дээр тайлбарла."
        }
      ],
      "temperature": 0.7,
      "max_tokens": 300,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return data["choices"][0]["message"]["content"].toString().trim();
  } else {
    throw Exception("GPT error: ${response.statusCode} ${response.body}");
  }
}
