import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/tracker.dart';

class BloodSugarChart extends StatefulWidget {
  final bool animate;
  final String userID;
  const BloodSugarChart({Key? key, 
    required this.animate,
    required this.userID,
  }) : super(key: key);

  @override
  _BloodSugarChartState createState() => _BloodSugarChartState();
}

class _BloodSugarChartState extends State<BloodSugarChart> {
  late BloodSugarTracker bloodSugar;

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
          // Placeholder: real chart removed to resolve dependency conflicts.
          return Container(
            height: 200,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: const Text('Chart unavailable (charts_flutter removed)'),
          );
        });
  }

  Future<List> _createSampleData() async {
    bloodSugar = BloodSugarTracker();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(widget.userID)
        .collection('blood_sugar')
        .get();

    List list = bloodSugar.loadData(snapshot);
    return list;
  }
}
