import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widget/medicine_list_styled.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFeef4ff), 
      appBar: AppBar(
        title: const Text('Миний эмнүүд'),
        backgroundColor: Color(0xFF1D3557),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Гарлаа')),
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: MedicineListStyled(), 
      ),
    );
  }
}
