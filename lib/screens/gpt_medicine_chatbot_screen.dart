import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../services/chimege_tts.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class GptMedicineChatbotScreen extends StatefulWidget {
  const GptMedicineChatbotScreen({super.key});

  @override
  State<GptMedicineChatbotScreen> createState() =>
      _GptMedicineChatbotScreenState();
}

class _GptMedicineChatbotScreenState extends State<GptMedicineChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isLoading = false;

  final String openAiKey =
      "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"; 

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || text.trim().length < 3) {
      _showError("Зовиураа тодорхой бичнэ үү.");
      return;
    }

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    final prompt = '''
  Хэрэглэгчийн зовиур: "$text"

  Монгол хэл дээр эм санал болго, тусгай тэмдэгт ашиглахгүй, 2 өгүүлбэрээр хариул.
  ''';

    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer $openAiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-4o",
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "temperature": 0.6,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final rawReply = data['choices'][0]['message']['content'];
        // final reply = rawReply.length > 180
        //     ? rawReply.substring(0, 180).trim() + "..."
        //     : rawReply.trim();

        setState(() {
          _messages.add(ChatMessage(text: rawReply, isUser: false));
        });
      } else {
        setState(() {
          _messages.add(ChatMessage(
              text: "⚠️ Алдаа: ${response.statusCode}", isUser: false));
        });
      }
    } catch (e) {
      setState(() {
        _messages
            .add(ChatMessage(text: "⚠️ Сүлжээний алдаа: $e", isUser: false));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playTTS(String text) async {
    final cleanText = text
        .replaceAll(RegExp(r'[^\u0400-\u04FF\s\dA-Za-z?!.,\' '":-]'), '')
        .trim();
    if (cleanText.isEmpty) {
      _showError("Уншуулах текст олдсонгүй.");
      return;
    }

    Uint8List? audioData = await ChimegeTTS.synthesize(cleanText);
    if (audioData != null) {
      await _audioPlayer.play(BytesSource(audioData));
    } else {
      _showError("TTS уншуулахад алдаа гарлаа.");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.indigo[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(message.text)),
            if (!message.isUser)
              IconButton(
                icon: const Icon(Icons.volume_up),
                onPressed: () => _playTTS(message.text),
                tooltip: "Дуугаар унших",
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeef4ff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3557),
        title: const Text("💬 Эмийн зөвлөгөө чатбот"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (_, index) => _buildMessageBubble(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Жишээ: гэдэс өвдөх, халуурах...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.indigo),
                  onPressed: () => sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
