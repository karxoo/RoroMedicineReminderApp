import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../models/tracker.dart';

class WeightChart extends StatefulWidget {
  final bool animate;
  final String userID;
  const WeightChart({Key? key,
    required this.animate,
    required this.userID,
  }) : super(key: key);

  @override
  _WeightChartState createState() => _WeightChartState();
}

class _WeightChartState extends State<WeightChart> {
  late WeightTracker weightTracker;

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
    weightTracker = WeightTracker();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(widget.userID)
        .collection('weight')
        .get();

    List list = weightTracker.loadData(snapshot);
    return list;
  }
}
