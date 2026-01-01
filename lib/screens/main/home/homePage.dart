import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// replaced rich_alert dialog with standard AlertDialog
import 'package:roro_medicine_reminder/screens/reminder/medicine/medicine_reminder.dart';

import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../components/navBar.dart';
import '../../../services/notifications.dart';
import '../../../widgets/home_screen_widgets.dart';
import '../../more/notes/note_page.dart';
import '../../more/trackers/health_tracker.dart';
import '../../reminder/appoinment_reminder/appoinment_reminder_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotificationService notificationService;

  //AuthClass authClass = AuthClass();

  final auth = FirebaseAuth.instance;
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    notificationService = NotificationService();
    notificationService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: WillPopScope(
          onWillPop: () async {
            final shouldExit = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exit the App'),
                    content: const Text('Are you sure?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Text('Yes'),
                        onPressed: () {
                         Navigator.of(context).pop(true); // return true
                        },
                      ),
                      ElevatedButton(
                        child: const Text('No'),
                        onPressed: () {
                         Navigator.of(context).pop(false); // return false
                        },
                      ),
                    ],
                  );
                });
                  return shouldExit ?? false;
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overScroll) {
              overScroll.disallowIndicator();
              return true;
            },
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: height * 0.1,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.purple,
                            child: CardButton(
                              height: height * 0.2,
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.userDoctor,
                              size: width * (25 / 100),
                              color: Colors.purple[200],
                              borderColor: Colors.purple.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppoinmentReminder.routeName);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Appointment Reminder'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.yellowAccent,
                            child: CardButton(
                              height: height * (20 / 100),
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.capsules,
                              size: width * 0.2,
                              color: Colors.yellowAccent[700],
                              borderColor:
                                  Colors.yellowAccent.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MedicineReminder.routeName);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Medicine Intake Reminder'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                /*Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.green,
                            child: CardButton(
                              height: height * (20 / 100),
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.child,
                              size: width * (25 / 100),
                              color: Colors.green[200],
                              borderColor: Colors.green.withOpacity(0.75),
                            ),
                            onTap: () async {
                              Navigator.pushNamed(context, InitialSetupScreen.routeName);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Contact JagaMe',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.brown,
                            child: CardButton(
                              height: height * (20 / 100),
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.fileLines,
                              size: width * 0.2,
                              color: Colors.brown[200],
                              borderColor: Colors.brown.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, ViewDocuments.routeName);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Save Documents'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.06,
                ),*/
//               Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: Column(
                //                       children: <Widget>[
//                          InkWell(
//                            splashColor: Colors.redAccent,
//                            child: CardButton(
//                              height: screenHeight * 0.2,
//                              width: screenWidth * (35 / 100),
//                              icon: FontAwesomeIcons.heartbeat,
//                              size: screenWidth * (25 / 100),
//                              color: Color(0xffD83B36),
//                              borderColor: Color(0xffD83B36).withOpacity(0.75),
//                            ),
//                            onTap: () {
//                              if (heartRateSensor) {
//                                Navigator.pushNamed(
//                                    context, HeartRateScreen.id);
//                              } else {
//                                print('Heart Rate Sensor not available');
//                                showDialog(
//                                    context: context,
//                                    builder: (BuildContext context) {
//                                      return RichAlertDialog(
//                                        alertTitle:
//                                            richTitle("Function not available"),
//                                        alertSubtitle: richSubtitle(
//                                            'Sensor not available in device '),
//                                        alertType: RichAlertType.WARNING,
//                                        actions: <Widget>[
//                                          FlatButton(
//                                              child: Text("Ok"),
//                                              onPressed: () {
//                                                Navigator.pop(context);
//                                              }),
//                                        ],
//                                      );
//                                    });
//                              }
//                            },
//                          ),
//                          Padding(
//                            padding: EdgeInsets.only(top: 8.0),
//                            child: Text('Check your Heart rate'),
//                          ),
                /*InkWell(
                            splashColor: Colors.redAccent,
                            child: CardButton(
                              height: height * 0.2,
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.userInjured,
                              size: width * (25 / 100),
                              color: Color(0xffD83B36),
                              borderColor: Color(0xffD83B36).withOpacity(0.75),
                            ),
                            onTap: () async {
                              bool granted = await checkRequiredPermission();
                              if (granted) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return VideoCall(
                                        userID: loggedInUser.uid,
                                      );
                                    }));
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Urgent Video Call'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.brown,
                            child: CardButton(
                              height: height * (20 / 100),
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.fileLines,
                              size: width * 0.2,
                              color: Colors.brown[100],
                              borderColor: Colors.brown.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, ViewDocuments.routeName);
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Save Documents'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.06,
                ),*/
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.teal,
                            child: CardButton(
                              height: height * 0.2,
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.noteSticky,
                              size: width * (25 / 100),
                              color: Colors.teal[200],
                              borderColor: Colors.teal.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, NotePage.routeName);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Notes'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          InkWell(
                            splashColor: Colors.blue,
                            child: CardButton(
                              height: height * (20 / 100),
                              width: width * (35 / 100),
                              icon: FontAwesomeIcons.notesMedical,
                              size: width * 0.2,
                              color: Colors.blue[200],
                              borderColor: Colors.blue.withOpacity(0.75),
                            ),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) {
                                return const TrackerHome();
                              }));
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Health Tracker'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: height * (5 / 100),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          )),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  void getCurrentUser() async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
}
