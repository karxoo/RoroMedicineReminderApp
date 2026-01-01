import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/add_blood_pressure.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/blood_pressure/blood_pressure_tracker_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/sleep/add_sleep_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/sleep/sleep_tracker_screen.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/weight/add_weight.dart';
import 'package:roro_medicine_reminder/screens/more/trackers/weight/weight_tracker_screen.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';
import 'blood_sugar/add_blood_sugar.dart';
import 'blood_sugar/blood_sugar_tracker_screen.dart';

class TrackerHome extends StatefulWidget {
  const TrackerHome({Key? key}) : super(key: key);

  @override
  State<TrackerHome> createState() => _TrackerHomeState();
}

class _TrackerHomeState extends State<TrackerHome> {
  late Map<String, bool> hideMap, trackMap;

  initializeDisplayMap() {
    hideMap = <String, bool>{};
    trackMap = <String, bool>{};
    hideMap = {'sleep': true, 'weight': true, 'sugar': true, 'pressure': true};
    trackMap = {
      'sleep': false,
      'weight': true,
      'sugar': true,
      'pressure': true
    };
  }

  onHide(String type) {
    setState(() {
      hideMap[type] = false;
    });
  }

  @override
  void initState() {
    initializeDisplayMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: ListView(
        children: <Widget>[
          Center(
            child: Container(
              padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
              child: const Text(
                'Health Trackers',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TrackerCard(
            title: 'Sleep Tracker',
            subTitle:
                'How Long did you sleep last night ?\nTrack hours slept to understand sleep patterns.',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AddSleepScreen();
              }));
            },
            onHide: () => onHide('sleep'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const SleepTrackerScreen();
              }));
            },
            isHidden: hideMap['sleep'] ?? false,
            isTracking: true,
          ),
          TrackerCard(
            title: 'Weight Tracker',
            subTitle:
                '\nHow much did you weigh ? Track to see progress over time.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AddWeightScreen();
              }));
            },
            onHide: () => onHide('weight'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const WeightTrackerScreen();
              }));
            },
            isHidden: hideMap['weight'] ?? false,
            isTracking: trackMap['weight'] ?? false,
          ),
          TrackerCard(
            title: 'Blood Glucose',
            subTitle:
                '\nWhat\'s your blood sugar level ? Track to chart progress.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AddBloodSugarScreen();
              }));
            },
            onHide: () => onHide('sugar'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const BloodSugarTrackerScreen();
              }));
            },
            isHidden: hideMap['sugar'] ?? false,
            isTracking: trackMap['sugar'] ?? false,
          ),
          TrackerCard(
            title: 'Blood Pressure',
            subTitle:
                '\nWhat\'s your blood pressure reading ?Track to see progress over time.\n',
            onAdd: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const AddBloodPressureScreen();
              }));
            },
            onHide: () => onHide('pressure'),
            onView: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return const BloodPressureTrackerScreen();
              }));
            },
            isHidden: hideMap['pressure'] ?? false,
            isTracking: trackMap['pressure'] ?? false,
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class TrackerCard extends StatelessWidget {
  final String title, subTitle;
  final onHide, onAdd, onView;
  final bool isTracking, isHidden;

  const TrackerCard(
      {Key? key, this.title = "",
      required this.isHidden,
      required this.onAdd,
      required this.onHide,
      required this.subTitle,
      required this.onView,
      required this.isTracking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isHidden) {
      return Card(
        elevation: 2,
        color: Colors.grey.shade50,
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width / 1.2,
          height: MediaQuery.of(context).size.height / 3.3,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /*FaIcon(
                        FontAwesomeIcons.poll,
                        color: Color(0xff3d5afe),
                      ),*/
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  subTitle,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isTracking
                      ? ElevatedButton(
                          onPressed: onView,
                          style: ElevatedButton.styleFrom(
                            elevation: 2, backgroundColor: const Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100]!,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: const Text(
                            'View Chart',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: onHide,
                          style: ElevatedButton.styleFrom(
                            elevation: 2, backgroundColor: const Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100]!,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: const Text(
                            'Hide',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                      elevation: 2, backgroundColor: const Color(0xffff9987),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.redAccent[100]!,
                          )),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: const Text("Add Data",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
