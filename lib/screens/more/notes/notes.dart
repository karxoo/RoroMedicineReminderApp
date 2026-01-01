import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String title = "";
  String des = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const ROROAppBar(),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent[100],
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 18.0,
                      ),
                    ),
                    //
                    ElevatedButton(
                      onPressed: add,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent[100],
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Mulish",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                //
                const SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        onChanged: (val) {
                          title = val;
                        },
                      ),
                      //
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: "Mulish",
                            color: Colors.grey,
                          ),
                          onChanged: (val) {
                            des = val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(),
      ),
    );
  }

  void add() async {
    // save to db
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('notes');

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
    };

    ref.add(data);

    //

    Navigator.pop(context);
  }
}