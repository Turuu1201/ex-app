import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  final sexController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    setState(() => _isLoading = true);

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      firstNameController.text = data['firstName'] ?? '';
      lastNameController.text = data['lastName'] ?? '';
      ageController.text = data['age']?.toString() ?? '';
      sexController.text = data['sex'] ?? '';
      heightController.text = data['height']?.toString() ?? '';
      weightController.text = data['weight']?.toString() ?? '';
      phoneController.text = data['phone'] ?? '';
      addressController.text = data['address'] ?? '';
    }

    setState(() => _isLoading = false);
  }

  Future<void> saveUserData() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'age': int.tryParse(ageController.text) ?? 0,
      'sex': sexController.text.trim(),
      'height': double.tryParse(heightController.text) ?? 0.0,
      'weight': double.tryParse(weightController.text) ?? 0.0,
      'phone': phoneController.text.trim(),
      'address': addressController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Амжилттай хадгалагдлаа')),
    );
  }

  Widget buildCardTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Please enter $label'
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeef4ff),
      appBar: AppBar(
        backgroundColor: Color(0xFF1D3557),
        title: const Text("Миний бүртгэл"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    buildCardTextField(
                        controller: firstNameController, label: "Овог"),
                    buildCardTextField(
                        controller: lastNameController, label: "Нэр"),
                    buildCardTextField(
                        controller: ageController,
                        label: "Нас",
                        keyboardType: TextInputType.number),
                    buildCardTextField(
                        controller: sexController, label: "Хүйс"),
                    buildCardTextField(
                        controller: heightController,
                        label: "Өндөр",
                        keyboardType: TextInputType.number),
                    buildCardTextField(
                        controller: weightController,
                        label: "Жин",
                        keyboardType: TextInputType.number),
                    buildCardTextField(
                        controller: phoneController, label: "Утасны дугаар"),
                    buildCardTextField(
                        controller: addressController, label: "Хаяг"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveUserData,
                      child: const Text("Хадгалах"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
