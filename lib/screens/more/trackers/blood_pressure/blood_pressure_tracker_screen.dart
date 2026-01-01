import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class BloodPressureTrackerScreen extends StatefulWidget {
  const BloodPressureTrackerScreen({Key? key}) : super(key: key);

  @override
  _BloodPressureTrackerScreenState createState() =>
      _BloodPressureTrackerScreenState();
}

class _BloodPressureTrackerScreenState
    extends State<BloodPressureTrackerScreen> {
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? "";
    });
  }

  late QuerySnapshot snapshot;
  late String userId;
  late double averageDiastolic, averageSystolic, averagePulse;
  late BloodPressureTracker bloodPressure;
  getDocumentList() async {
    bloodPressure = BloodPressureTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('blood_pressure')
        .get();
    averageDiastolic = 0;
    double totalDiastolic = 0, totalSystolic = 0, totalPulse = 0;

    List<BloodPressure> list = bloodPressure.loadData(snapshot);
    for (var s in list) {
      totalDiastolic += s.diastolic ?? 0.00;
      totalSystolic += s.systolic ?? 0.00;
      totalPulse += s.pulse ?? 0.00;
    }

    setState(() {
      averageDiastolic = totalDiastolic / list.length;
      averageSystolic = totalSystolic / list.length;
      averagePulse = totalPulse / list.length;
    });

    return snapshot;
  }

  late PageController _controller;

  @override
  void initState() {
    getCurrentUser();
    _controller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
         StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('bloodPressure').snapshots(),
  builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: const Text(
                            'Diastolic ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(shrinkWrap: true, children: <Widget>[
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'diastolic',
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Average Diastolic '),
                          title: Text(averageDiastolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
          StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('bloodPressure').snapshots(),
  builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: const Text(
                            'Systolic',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(shrinkWrap: true, children: <Widget>[
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'systolic',
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Average Systolic'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
         StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('bloodPressure').snapshots(),
  builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: const Text(
                            'Pulse',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ListView(shrinkWrap: true, children: <Widget>[
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: userId,
                                type: 'pulse',
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Average Pulse'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              })
        ],
      ),
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
