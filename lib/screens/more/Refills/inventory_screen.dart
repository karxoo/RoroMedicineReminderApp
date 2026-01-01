import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_sugar/chart_widget.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';
import '../../../../models/tracker.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid;
    });
  }

  late QuerySnapshot snapshot;
  late String? userId;
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
      totalValue += s.bloodSugar ?? 0;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: const Text(
                'Inventory',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
         StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('profile').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   final docs = snapshot.data!.docs;
  if (docs.isEmpty) {
    return const Center(child: Text("No data available"));
  }
                  return Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodSugarChart(
                                animate: true,
                                userID: userId ?? '0',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: const Text('Inventory'),
                          title: Text(averageValue.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
        ],
      ),
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
