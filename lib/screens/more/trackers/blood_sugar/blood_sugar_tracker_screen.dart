import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_sugar/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class BloodSugarTrackerScreen extends StatefulWidget {
  const BloodSugarTrackerScreen({Key? key}) : super(key: key);

  @override
  _BloodSugarTrackerScreenState createState() =>
      _BloodSugarTrackerScreenState();
}

class _BloodSugarTrackerScreenState extends State<BloodSugarTrackerScreen> {
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? "";
    });
  }

  late QuerySnapshot snapshot;
  late String userId;
  late double averageValue;
  late BloodSugarTracker bloodSugar;
  getDocumentList() async {
    bloodSugar = BloodSugarTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_sugar')
        .get();
    averageValue = 0;
    double totalValue = 0;

    List<BloodSugar> list = bloodSugar.loadData(snapshot);
    for (var s in list) {
      totalValue += s.bloodSugar ?? 0.00;
    }

    setState(() {
      averageValue = totalValue / list.length;
    });

    return snapshot;
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: const Text(
                'Blood Sugar Tracker',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('bloodsugar').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                      shrinkWrap: true,
                      //scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data!.docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodSugarChart(
                                animate: true,
                                userID: userId,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          child: ListTile(
                            subtitle: const Text('Average Blood Sugar'),
                            title: Text(averageValue.toStringAsFixed(2)),
                          ),
                        )
                      ]);
                } else {
                  return const SizedBox();
                }
              }),
        ],
      )),
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
