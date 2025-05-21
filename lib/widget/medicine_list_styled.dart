import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicineListStyled extends StatelessWidget {
  const MedicineListStyled({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text("Нэвтрээгүй хэрэглэгч"));
    }

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('medicines')
        .orderBy('time'); 

    return StreamBuilder<QuerySnapshot>(
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Эм нэмэгдээгүй байна."));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;

            final time = data['time'] ?? '08:00';
            final name = data['name'] ?? 'Тодорхойгүй';
            final dose = data['dose'] ?? '1 pill';
            final icon = Icons.medication_outlined;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.indigo.shade100,
                    child: Icon(icon, color: Colors.indigo),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text("$dose\n$time"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Устгах уу?"),
                          content: Text("“$name” эмийг устгах уу?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Үгүй"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text("Тийм"),
                            ),
                          ],
                        ),
                      );

                      if (shouldDelete == true) {
                        await docs[index].reference.delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Эм устгагдлаа")),
                        );
                      }
                    },
                  ),
                  isThreeLine: true,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
