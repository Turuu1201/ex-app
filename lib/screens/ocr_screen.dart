import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/getDrugDescription.dart';

class OcrScreen extends StatefulWidget {
  const OcrScreen({super.key});

  @override
  State<OcrScreen> createState() => _OcrScreenState();
}

class _OcrScreenState extends State<OcrScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  List<String> _medicineNames = [];

  final Map<String, String> medicineTranslations = {
    "paracetamol": "Парацетамол",
    "ibuprofen": "Ибупрофен",
    "amoxicillin": "Амоксициллин",
    "tylenol": "Тайленол",
    "acetaminophen": "Ацетаминофен",
    "nimesil": "Нимесил",
    "aspirin": "Аспирин",
    "claritin": "Кларитин",
    "azithromycin": "Азитромицин",
    "panadol": "Панадол",
  };

  Future<void> _pickImageAndProcess() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _isLoading = true;
      _medicineNames.clear();
    });

    final inputImage = InputImage.fromFile(File(pickedFile.path));
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final result = await textRecognizer.processImage(inputImage);
    final recognizedText = result.text;
    textRecognizer.close();

    final names = extractMedicineNamesFromText(recognizedText);
    setState(() {
      _medicineNames = names.take(10).toList();
      _isLoading = false;
    });

    if (_medicineNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Эмийн нэр илэрсэнгүй")),
      );
    }
  }

  List<String> extractMedicineNamesFromText(String text) {
    final lines = text.split('\n');
    final List<String> meds = [];

    for (var line in lines) {
      line = line.trim();

      if (line.isNotEmpty &&
          line.length < 30 &&
          RegExp(r"^[A-Z][A-Z0-9\s\-]{2,}").hasMatch(line)) {
        meds.add(line);
      }

      if (RegExp(
              r'\b(paracetamol|ibuprofen|amoxicillin|tylenol|acetaminophen|nimesil|aspirin|claritin|azithromycin|panadol)\b',
              caseSensitive: false)
          .hasMatch(line)) {
        meds.add(line);
      }
    }

    return meds.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeef4ff),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D3557),
        title: const Text('Эмийн нэр OCR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImageAndProcess,
              child: const Text('📷 Зураг оруулах'),
            ),
            const SizedBox(height: 10),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView(
                      children: [
                        if (_medicineNames.isNotEmpty)
                          const Text(
                            "Илэрсэн эм:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        for (final name in _medicineNames)
                          if (medicineTranslations
                              .containsKey(name.trim().toLowerCase()))
                            Card(
                              child: ListTile(
                                leading: const Icon(Icons.medication),
                                title: Text(
                                  medicineTranslations[
                                      name.trim().toLowerCase()]!,
                                ),
                                onTap: () async {
                                  final scaffold =
                                      ScaffoldMessenger.of(context);
                                  final navigator = Navigator.of(context);

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const AlertDialog(
                                      content: SizedBox(
                                        height: 80,
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                  );

                                  try {
                                    final description =
                                        await getDrugDescription(name);
                                    navigator.pop(); // Close loading dialog

                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(
                                            " ${medicineTranslations[name.trim().toLowerCase()]!}"),
                                        content: Text(description),
                                        actions: [
                                          TextButton(
                                            onPressed: () => navigator.pop(),
                                            child: const Text('Хаах'),
                                          ),
                                        ],
                                      ),
                                    );
                                  } catch (e) {
                                    navigator.pop();
                                    scaffold.showSnackBar(
                                      SnackBar(
                                          content: Text("Алдаа гарлаа: $e")),
                                    );
                                  }
                                },
                              ),
                            ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
