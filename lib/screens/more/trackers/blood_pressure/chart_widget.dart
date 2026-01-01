import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/tracker.dart';

class BloodPressureChart extends StatefulWidget {
  final bool animate;
  final String userID, type;
  const BloodPressureChart({
    Key? key,
    required this.animate,
    required this.userID,
    required this.type,
  }) : super(key: key);

  @override
  _BloodPressureChartState createState() => _BloodPressureChartState();
}

class _BloodPressureChartState extends State<BloodPressureChart> {
  late BloodPressureTracker bloodPressure;

  @override
  void initState() {
    _createSampleData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _createSampleData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: const Text('Chart unavailable (charts_flutter removed)'),
          );
        });
  }

  Future<List> _createSampleData() async {
    bloodPressure = BloodPressureTracker();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(widget.userID)
        .collection('blood_pressure')
        .get();

    List list = bloodPressure.loadData(snapshot);
    return list;
  }
}
