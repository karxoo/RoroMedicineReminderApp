import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';
import '../../../../widgets/app_default.dart';
import 'chart_widget.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({Key? key}) : super(key: key);

  @override
  _SleepTrackerScreenState createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? "";
    });
  }

  late QuerySnapshot snapshot;
  late String userId;
  late double averageSleep;
  late SleepTracker sleepTracker;
  getDocumentList() async {
    sleepTracker = SleepTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('sleep')
        .get();
    averageSleep = 0;
    double totalSleep = 0;
    List<Sleep> list = sleepTracker.loadData(snapshot);
   for (var s in list) {
  if (s.hours != null && s.minutes != null) {
    totalSleep += s.hours! + s.minutes! / 60;
  }
}

    setState(() {
      averageSleep = totalSleep / list.length;
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
                'Sleep Tracker',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('bloodPressure').snapshots(),
  builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(15),
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 1.7,
                          maxWidth: MediaQuery.of(context).size.width *
                              (snapshot.data!.docs.length / 3),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TimeChart(
                              animate: true,
                              userID: userId,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Average Sleep'),
                          title: Text(averageSleep.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
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
