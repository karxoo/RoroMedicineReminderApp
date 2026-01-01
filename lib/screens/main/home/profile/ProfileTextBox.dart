import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileTextBox extends StatefulWidget {
  final String title, value, name;

  const ProfileTextBox({Key? key, 
  this.title = "", 
  this.value = "", 
  this.name = ""}) : super(key: key);

  @override
  _ProfileTextBoxState createState() => _ProfileTextBoxState();
}

class _ProfileTextBoxState extends State<ProfileTextBox> {
  @override
  void initState() {
    getCurrentUser();
    controller =
        TextEditingController.fromValue(TextEditingValue(text: widget.value));
    super.initState();
  }

  late TextEditingController controller;

  late String? currentUserId;

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    currentUserId = user?.uid ?? '';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: TextField(
          controller: controller,
          onChanged: (v) async {
            await FirebaseFirestore.instance
                .collection('profile')
                .doc(currentUserId)
                .update({widget.name: v});
          },

          style: const TextStyle(color: Colors.black), //const Color(0xffeeeff1) ),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffeeeff1)),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              labelStyle: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
              labelText: widget.title.toUpperCase()),
        ),
      ),
    );
  }
}
