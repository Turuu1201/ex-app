import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final nameController = TextEditingController();
  final doseController = TextEditingController();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> addMedicineForUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || selectedTime == null) return;

    final formattedTime = selectedTime!.format(context);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('medicines')
        .add({
      'name': nameController.text.trim(),
      'dose': doseController.text.trim(),
      'time': formattedTime,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Эм амжилттай нэмэгдлээ')),
    );

    nameController.clear();
    doseController.clear();
    setState(() => selectedTime = null);
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  Widget buildCardTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeText =
        selectedTime != null ? selectedTime!.format(context) : 'Цаг сонгоогүй';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Эм нэмэх'),
        backgroundColor: const Color(0xFF1D3557),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildCardTextField(controller: nameController, label: 'Эмийн нэр'),
            buildCardTextField(controller: doseController, label: 'Тун'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text("Уух цаг: $timeText")),
                ElevatedButton(
                    onPressed: pickTime, child: const Text("Цаг сонгох")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addMedicineForUser,
              child: const Text('Хадгалах'),
            ),
          ],
        ),
      ),
    );
  }
}
