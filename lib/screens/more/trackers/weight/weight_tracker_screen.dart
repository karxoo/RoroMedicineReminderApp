import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/weight/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class WeightTrackerScreen extends StatefulWidget {
  const WeightTrackerScreen({Key? key}) : super(key: key);

  @override
  _WeightTrackerScreenState createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user!.uid;
    });
  }

  late QuerySnapshot snapshot;
  late String userId;
  late double averageWeight;
  late WeightTracker weightTracker;
  getDocumentList() async {
    weightTracker = WeightTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(userId)
        .collection('weight')
        .get();
    averageWeight = 0;
    double totalWeight = 0;

    List<Weight> list = weightTracker.loadData(snapshot);
    for (var s in list) {
      totalWeight += (s.weight as num?) ?? 0.0;
    }
    setState(() {
      averageWeight = totalWeight / list.length;
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
                'Weight Tracker',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('weights').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(15),
                        constraints: BoxConstraints(
                          //minWidth: MediaQuery.of(context).size.width ,
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
                            child: WeightChart(
                              animate: true,
                              userID: userId,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Average Weight'),
                          title: Text(averageWeight.toStringAsFixed(2)),
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
