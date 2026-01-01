import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:intl/intl.dart';
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';
import 'package:roro_medicine_reminder/services/database_helper.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';
import 'package:sqflite/sqflite.dart';

import '../../../components/navBar.dart';
import '../../../models/appoinment.dart';
import 'appoinment_decision_screen.dart';
import 'appoinment_detail_screen.dart';

class AppoinmentReminder extends StatefulWidget {
  static const String routeName = 'Appoinment_Reminder_Screen';

  const AppoinmentReminder({Key? key}) : super(key: key);
  @override
  _AppoinmentReminderState createState() => _AppoinmentReminderState();
}

class _AppoinmentReminderState extends State<AppoinmentReminder> {
  var rng = Random();
  var kTextStyle = const TextStyle(
      color: Colors.brown, fontSize: 15, fontWeight: FontWeight.w700);
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Appoinment> appoinmentList = [];
  late Appoinment appoinment;
  int count = 0;
  int? tempDay, tempMonth, tempYear, tempHour, tempMinute;

  DateTime dateTime = DateTime.now();
  String year = DateTime.now().year.toString();
  String month = '';
  Map<int, String> months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  getMonth() {
    int monthDay = dateTime.month;
    month = months[monthDay] ?? '';
  }

  DateTime today = DateTime.now();

  final f = DateFormat('yyyy-MM-dd hh:mm');
  @override
  void initState() {
    todayAppoinment = [];
    upcomingAppoinment = [];
    pastAppoinment = [];
    appoinment = Appoinment(
        '', '', DateTime.now().toString(), '', rng.nextInt(99999), false);
    getMonth();
    getTextWidgets();

    super.initState();
  }

  List<Widget> textWidgets = [];

  getTextWidgets() {
    int month = dateTime.month;
    int year = dateTime.year;
    int day = dateTime.day;
    int endDay;
    if (month == 1 ||
        month == 3 ||
        month == 5 ||
        month == 7 ||
        month == 8 ||
        month == 12 ||
        month == 10) {
      endDay = 31;
    } else if (month == 2) {
      if (year % 4 == 0) {
        endDay = 29;
      } else {
        endDay = 28;
      }
    } else {
      endDay = 30;
    }
    Widget today = CircleAvatar(
      backgroundColor: Colors.redAccent[100],
      child: Text(
        day.toString(),
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
    int start = 1;
    for (var i = day; i <= day + 4; i++) {
      if (i > endDay) {
        textWidgets.add(Text(start.toString()));
        start++;
      } else {
        if (i == day) {
          textWidgets.add(today);
        } else {
          textWidgets.add(Text(i.toString()));
        }
      }
    }
  }

  late List<Appoinment> todayAppoinment;
  late List<Appoinment> upcomingAppoinment;
  late List<Appoinment> pastAppoinment;

  Future getTodayAppoinment() async {
    if (appoinmentList.isEmpty) return;
    setState(() {
      todayAppoinment = [];
      for (Appoinment tempAppoinment in appoinmentList) {
        DateTime date = DateTime.parse(
            tempAppoinment.dateAndTime ?? DateTime.now().toString());

        if (today.day == date.day &&
            today.month == date.month &&
            today.year == date.year &&
            !(tempAppoinment.done ?? false)) {
          todayAppoinment.add(tempAppoinment);
        }
      }
    });
  }

  Future getUpcomingAppoinment() async {
    if (appoinmentList.isEmpty) return;
    setState(() {
      upcomingAppoinment = [];

      for (Appoinment tempAppoinment in appoinmentList) {
        DateTime date = DateTime.parse(
            tempAppoinment.dateAndTime ?? DateTime.now().toString());

        if (!todayAppoinment.contains(tempAppoinment)) {
          if (today.isBefore(date)) {
            upcomingAppoinment.add(tempAppoinment);
          }
        }
      }
    });
  }

  Future getPastAppoinment() async {
    if (appoinmentList.isEmpty) return;
    setState(() {
      pastAppoinment = [];

      for (Appoinment tempAppoinment in appoinmentList) {
        DateTime date = DateTime.parse(
            tempAppoinment.dateAndTime ?? DateTime.now().toString());

        if (date.isBefore(today) && !todayAppoinment.contains(tempAppoinment)) {
          pastAppoinment.add(tempAppoinment);
        }
      }
    });
  }

  List<Widget> getPastAppoinmentWidget(BuildContext context) {
    pastAppoinment.sort((a, b) {
      // Safely handle nulls when sorting
      final aDate = a.dateAndTime != null
          ? DateTime.parse(a.dateAndTime!)
          : DateTime(1900);
      final bDate = b.dateAndTime != null
          ? DateTime.parse(b.dateAndTime!)
          : DateTime(1900);
      return bDate.compareTo(aDate);
    });

    List<Widget> pastAppoinmentWidgetList = [];

    for (Appoinment tempAppoinment in pastAppoinment) {
      String date, time;

      if (tempAppoinment.dateAndTime == null) {
        // Skip appointments without a date
        continue;
      }

      dateTime = DateTime.parse(tempAppoinment.dateAndTime!);

      date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      if (dateTime.minute == 0) {
        time = '${dateTime.hour}:${dateTime.minute}0';
      } else if (dateTime.minute < 10)
        time = '${dateTime.hour}:0${dateTime.minute}';
      else
        time = '${dateTime.hour}:${dateTime.minute}';
      pastAppoinmentWidgetList.add(Builder(
        builder: (context) => InkWell(
            onLongPress: () async {
              //_showSnackBar(context, 'Appoinment Deleted');
              _delete(context, tempAppoinment);
            },
            highlightColor: Colors.white70,
            child: OtherAppoinment(
              name: tempAppoinment.name ?? 'Unknown',
              type: tempAppoinment.address ?? 'No address',
              time: time,
              date: date,
            )),
      ));
    }

    return pastAppoinmentWidgetList;
  }

  List<Widget> getUpcomingAppoinmentWidget(BuildContext context) {
    upcomingAppoinment.sort((a, b) {
      final aDate = a.dateAndTime != null
          ? DateTime.parse(a.dateAndTime!)
          : DateTime(1900);
      final bDate = b.dateAndTime != null
          ? DateTime.parse(b.dateAndTime!)
          : DateTime(1900);
      return bDate.compareTo(aDate);
    });
    List<Widget> upcomingAppoinmentWidgetList = [];

    for (Appoinment tempAppoinment in upcomingAppoinment) {
      String date, time;
      dateTime = DateTime.parse(tempAppoinment.dateAndTime!);
      date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      if (dateTime.minute == 0) {
        time = '${dateTime.hour}:${dateTime.minute}0';
      } else if (dateTime.minute < 10)
        time = '${dateTime.hour}:0${dateTime.minute}';
      else
        time = '${dateTime.hour}:${dateTime.minute}';
      upcomingAppoinmentWidgetList.add(Builder(
        builder: (context) => InkWell(
            onTap: () {
              navigateToDetail(tempAppoinment, 'Edit');
            },
            onLongPress: () async {
              _showSnackBar(context, 'Appoinment Deleted');
              _delete(context, tempAppoinment);
            },
            child: OtherAppoinment(
              name: tempAppoinment.name ?? 'Unknown',
              type: tempAppoinment.address ?? 'No adress',
              time: time,
              date: date,
            )),
      ));
    }

    return upcomingAppoinmentWidgetList;
  }

  List<Widget> getTodayAppoinmentWidget(BuildContext context) {
    todayAppoinment.sort((a, b) {
      final aDate = a.dateAndTime != null
          ? DateTime.parse(a.dateAndTime!)
          : DateTime(1900);
      final bDate = b.dateAndTime != null
          ? DateTime.parse(b.dateAndTime!)
          : DateTime(1900);
      return bDate.compareTo(aDate);
    });

    List<Widget> todayAppoinmentWidgetList = [];
    Color color = Colors.green;
    for (Appoinment tempAppoinment in todayAppoinment) {
      dateTime = DateTime.parse(tempAppoinment.dateAndTime!);

      String time;
      if (dateTime.minute == 0) {
        time = '${dateTime.hour}:${dateTime.minute}0';
      } else if (dateTime.minute < 10)
        time = '${dateTime.hour}:0${dateTime.minute}';
      else
        time = '${dateTime.hour}:${dateTime.minute}';
      todayAppoinmentWidgetList.add(
        Card(
          margin: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                print('tap');
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AppoinmentDecision(tempAppoinment);
                }));
              },
              onLongPress: () async {
                _showSnackBar(context, 'Appoinment Done');
                setState(() {
                  tempAppoinment.done = true;
                  color = Colors.yellow;
                });
                await databaseHelper.updateAppoinment(tempAppoinment);
              },
              leading: CircleAvatar(
                backgroundColor: color,
                radius: 38,
                child: const Icon(
                  FontAwesomeIcons.userDoctor,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              title: Text(
                tempAppoinment.name ?? 'Unknown',
                style: kTextStyle.copyWith(
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              trailing: Text(time),
              subtitle:
                  Text('${tempAppoinment.address} at ${tempAppoinment.place}'),
            ),
          ),
        ),
      );
    }

    return todayAppoinmentWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    if (appoinmentList.isEmpty) {
      updateListView();
    }

    // update derived lists if we have data
    if (appoinmentList.isNotEmpty) {
      getTodayAppoinment();
      getUpcomingAppoinment();
      getPastAppoinment();
    }
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const HomePage();
          }));
          return false;
        },
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 35,
            ),
            Text(
              '$month  $year',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Colors.blueGrey),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: textWidgets),
            const SizedBox(
              height: 20,
            ),
            todayAppoinment.isEmpty
                ? const Center(
                    child: Text(
                      'No Appointments today',
                    ),
                  )
                : Column(
                    children: getTodayAppoinmentWidget(context),
                  ),
            const SizedBox(
              height: 17,
            ),
            const HeadingText(
              title: 'Upcoming',
              color: Colors.teal,
            ),
            const SizedBox(
              height: 8,
            ),
            upcomingAppoinment.isNotEmpty
                ? Column(
                    children: getUpcomingAppoinmentWidget(context),
                  )
                : const Center(child: Text('No Upcoming Appointments')),
            const SizedBox(
              height: 15,
            ),
            const HeadingText(
              title: 'Past Appointments',
              color: Colors.deepOrangeAccent,
            ),
            const SizedBox(
              height: 10,
            ),
            pastAppoinment.isNotEmpty
                ? Column(
                    children: getPastAppoinmentWidget(context),
                  )
                : Container(
                    margin: const EdgeInsets.only(bottom: 35),
                    child: const Center(
                      child: Text('No past Appointments'),
                    ),
                  ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          navigateToDetail(appoinment, 'Add');
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: const ROROAppBar(),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  void _delete(BuildContext context, Appoinment appoinment) async {
    int result = await databaseHelper.deleteAppoinment(appoinment.id ?? 0);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(Appoinment appoinment, String name) async {
    final navigator = Navigator.of(context);
    final result =
        await navigator.push<bool>(MaterialPageRoute(builder: (context) {
      return AppoinmentDetail(appoinment, name);
    }));
    if (!mounted) return;
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Appoinment>> appoinmentListFuture =
          databaseHelper.getAppoinmentList();
      appoinmentListFuture.then((appoinmentList) {
        setState(() {
          this.appoinmentList = appoinmentList;
          count = appoinmentList.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class HeadingText extends StatelessWidget {
  final String title;
  final color;
  const HeadingText({Key? key, this.color, this.title = ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 20),
      child: Text(
        '$title :',
        style:
            TextStyle(color: color, fontSize: 23, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class OtherAppoinment extends StatelessWidget {
  final String time, date, type, name;
  const OtherAppoinment(
      {Key? key,
      required this.name,
      required this.date,
      required this.type,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 8),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
          //color: Colors.grey,
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(25), right: Radius.circular(25))),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(
            width: 25,
          ),
          Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Dr.$name',
                    style: const TextStyle(
                        fontSize: 19,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    type,
                    style: const TextStyle(color: Colors.brown, fontSize: 16),
                  ),
                  const SizedBox(height: 5)
                ],
              )),
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    date,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class TodayAppoinment extends StatelessWidget {
  const TodayAppoinment({
    Key? key,
    required this.kTextStyle,
    required this.type,
    required this.name,
    required this.place,
    required this.time,
  }) : super(key: key);

  final TextStyle kTextStyle;
  final String time, place, name, type;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      decoration: BoxDecoration(
        color: const Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                const CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 38,
                  child: Icon(
                    FontAwesomeIcons.userDoctor,
                    size: 43,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8),
                  child: Text(
                    time,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Dr. $name',
              style: kTextStyle.copyWith(
                  letterSpacing: 1, fontWeight: FontWeight.bold, fontSize: 19),
            ),
          )
        ],
      ),
    );
  }
}
