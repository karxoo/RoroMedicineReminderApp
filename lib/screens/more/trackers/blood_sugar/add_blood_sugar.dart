import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_sugar/blood_sugar_tracker_screen.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';
import '../health_tracker.dart';

class AddBloodSugarScreen extends StatefulWidget {
  const AddBloodSugarScreen({Key? key}) : super(key: key);

  @override
  _AddBloodSugarScreenState createState() => _AddBloodSugarScreenState();
}

class _AddBloodSugarScreenState extends State<AddBloodSugarScreen> {
  final _trackerKey = GlobalKey<FormState>();
  late TextEditingController bloodSugar, notes;
  late BloodSugarTracker bloodSugarTracker;

  @override
  void initState() {
    bloodSugarTracker = BloodSugarTracker();
    bloodSugar = TextEditingController(text: '');
    notes = TextEditingController(text: '');
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: const Text(
                  'Add Blood Sugar Data',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "Mulish",
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _trackerKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: bloodSugar,
                      decoration: InputDecoration(
                        hintText: 'Blood sugar in mg/dL',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      onChanged: (v) {
                        _trackerKey.currentState?.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter value';
                        } else {
                          if (!isNumeric(value)) {
                            return 'Enter numeric value';
                          }

                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (v) {
                        _trackerKey.currentState?.validate();
                      },
                      controller: notes,
                      decoration: InputDecoration(
                        hintText: 'Notes about Blood Sugar ',
                        border: const OutlineInputBorder(),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter value';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      _trackerKey.currentState?.validate();
                      final navigator = Navigator.of(context);
                      await saveData();
                      if (!mounted) return;
                      navigator.pop();
                      navigator.push(MaterialPageRoute(
                          builder: (_) => const BloodSugarTrackerScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: const Color(0xffff9987),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text("Add Data",
                        style: TextStyle(fontFamily: 'Mulish', fontSize: 18)),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TrackerHome()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      backgroundColor: const Color(0xffff9987),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.redAccent[100]!,
                          )),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Mulish',
                          //fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ]),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(' '),
            )
          ],
        ),
      ),
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  saveData() async {
    bloodSugarTracker.bloodSugar = BloodSugar(
        bloodSugar: int.parse(bloodSugar.text),
        notes: notes.text,
        dateTime: DateTime.now());
    await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_sugar')
        .add(bloodSugarTracker.toMap());
  }

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? '';
    });
  }

  String userId = '';
}

bool isNumeric(String s) {
  return int.tryParse(s) != null;
}
