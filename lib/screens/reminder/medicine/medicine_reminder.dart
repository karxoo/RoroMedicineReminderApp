import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';
import 'package:sqflite/sqflite.dart';

import '../../../components/navBar.dart';
import '../../../models/reminder.dart';
import '../../../services/database_helper.dart';
import '../../../widgets/app_default.dart';
import '../../../widgets/home_screen_widgets.dart';
import 'medicine_decision_screen.dart';
import 'reminder_detail.dart';

class MedicineReminder extends StatefulWidget {
  static const String routeName = 'Medicine_home_screen';
  final Reminder reminder; // <-- pass reminder into the widget

  const MedicineReminder({
    Key? key,
    required this.reminder,
  }) : super(key: key);

  @override
  _MedicineReminderState createState() => _MedicineReminderState();
}

class _MedicineReminderState extends State<MedicineReminder> {
  late Reminder _reminder;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Reminder> reminderList = [];
  int count = 0;
  DateTime dateTime = DateTime.now();
  String today = '';
  Map<int, String> weekDays = {};
  List<Reminder> nearReminders = [];
  Map<Reminder, Map<int, DateTime>> reminderMap =
      <Reminder, Map<int, DateTime>>{};
  List<Reminder> doneReminders = [];
  int weekDayNumber = 0;
  getWeekDays() {
    weekDays = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun'
    };
    weekDayNumber = dateTime.weekday;
    today = weekDays[weekDayNumber] ?? '';
  }

  bool set = false;
  List<Widget> weekDayWidgets = [];
  List<Widget> getWeekDayWidgets() {
    Widget widget;
    weekDayWidgets = [];
    for (int i = 1; i <= 7; i++) {
      if (i == weekDayNumber) {
        widget = Text(
          weekDays[i]?.toUpperCase() ?? '',
          style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        );
      } else {
        widget = Text(
          weekDays[i]?.toUpperCase() ?? '',
          style: const TextStyle(
            fontSize: 20,
          ),
        );
      }
      weekDayWidgets.add(Padding(
          padding: const EdgeInsets.only(left: 2, right: 2), child: widget));
    }
    return weekDayWidgets;
  }

  @override
  void initState() {
    set = false;
    _reminder = widget.reminder;
    updateListView();
    getWeekDays();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (reminderList == null) {
      reminderList = [];
      updateListView();
    }
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: count != 0
          ? WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
                return false;
              },
              child: getReminderListView())
          : Column(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        splashColor: Colors.green,
                        child: CardButton(
                          height: height * 0.2,
                          width: width * (35 / 100),
                          icon: FontAwesomeIcons.hospital,
                          size: width * (25 / 100),
                          color: Colors.green[200],
                          borderColor: Colors.green.withOpacity(0.75),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ReminderDetail(_reminder, 'Add Reminder');
                            //return ReminderDetail();
                          }));
                        },
                      ),
                      const Center(
                        //margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                        child: Text(
                          'You have no recent medicine reminder! \nClick to add one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Widget getReminderListView() {
    checkReminders();
    List<Widget> list = [];

    reminderMap.forEach((rem, map) {
      map.forEach((time, date) {
        var card = Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: const EdgeInsets.all(8),
          child: ListTile(
            trailing: const Icon(
              Icons.notification_important,
              color: Colors.orange,
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return MedicineDecisionScreen(rem);
              }));
            },
            title: Text(rem?.name ?? ''),
            subtitle: Text(DateFormat.jm().format(date)),
          ),
        );
        if (!list.contains(card)) list.add(card);
      });
    });

    double width = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        reminderMap.isNotEmpty
            ? Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: const Text(
                      'Medicines in the next few Hours',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        children: list,
                      )),
                ],
              )
            : Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                padding: const EdgeInsets.only(top: 15, bottom: 6),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: getWeekDayWidgets(),
                ),
              ),
        Stack(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.5),
              margin: const EdgeInsets.only(
                  top: 35, left: 10, right: 10, bottom: 0),
              padding: const EdgeInsets.only(top: 12, bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: count,
                  itemBuilder: (BuildContext context, int position) {
                    return Dismissible(
                      onDismissed: (direction) {
                        _delete(context, reminderList[position]);
                        reminderList.removeAt(position);
                        setState(() {
                          _showSnackBar(context, 'Reminder Deleted');
                        });
                      },
                      key: Key(reminderList[position].id.toString()),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(38.0, 26, 38, 0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: InkWell(
                              onTap: () {
                                navigateToDetail(
                                    reminderList[position], 'Edit Reminder');
                              },
                              child: Column(children: <Widget>[
                                Center(
                                  child: Text(
                                    reminderList[position]
                                            .name
                                            ?.toUpperCase() ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${reminderList[position].times} times' ??
                                          '',
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              right: width / 3,
              left: width / 3,
              top: 0,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReminderDetail(_reminder, 'Add Reminder');
                    //return ReminderDetail();
                  }));
                },
                child: const Material(
                  shape: CircleBorder(),
                  elevation: 5,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 35,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  void _delete(BuildContext context, Reminder reminder) async {
    int result = await databaseHelper.deleteReminder(reminder?.id ?? 0);
    if (result != 0) {
      setState(() {
        updateListView();
        checkReminders();
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Reminder reminder, String name) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReminderDetail(reminder, name);
      //return ReminderDetail();
    }));

    if (result == true) {
      updateListView();
      checkReminders();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Reminder>> remListFuture = databaseHelper.getRemList();
      remListFuture.then((reminderList) {
        if (mounted) {
          setState(() {
            this.reminderList = reminderList;
            count = reminderList.length;
          });
        }
      });
    });
    checkReminders();
  }

  checkReminders() {
    nearReminders = [];
    reminderMap = <Reminder, Map<int, DateTime>>{};
    TimeOfDay now = TimeOfDay.now();
    TimeOfDay reminderTime;
    for (var reminder in reminderList) {
      if (!doneReminders.contains(reminder)) {
        if (reminder.time1 != null) {
          final reminderTime = getTimeOfDay(reminder.time1!);
          final result = compareTimes(now, reminderTime);

          if (result) {
            nearReminders.add(reminder);
            reminderMap[reminder] = {1: toDateTime(reminderTime)};
          }
        }
      }

      if (reminder.times != null && reminder.times! >= 2) {
        if (reminder.time2 != null) {
          final reminderTime = getTimeOfDay(reminder.time2!);
          final result = compareTimes(now, reminderTime);

          if (result) {
            nearReminders.add(reminder);

            // Ensure type safety: Map<int, DateTime>
            final tempMap = reminderMap[reminder] ?? <int, DateTime>{};

            tempMap[2] = toDateTime(reminderTime); // update slot 2
            reminderMap[reminder] = tempMap; // reassign back
          }
        }
      }
      if (reminder.times != null && reminder.times! >= 3) {
        if (reminder.time3 != null) {
          final reminderTime = getTimeOfDay(reminder.time3!);
          final result = compareTimes(now, reminderTime);

          if (result) {
            nearReminders.add(reminder);

            // Ensure type safety
            final tempMap = reminderMap[reminder] ?? <int, DateTime>{};

            // Always update slot 3
            tempMap[3] = toDateTime(reminderTime);
            reminderMap[reminder] = tempMap;
          }
        }
      }
    }

    nearReminders.toSet().toList();
  }
}

TimeOfDay getTimeOfDay(String time) {
  return TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]));
}

compareTimes(TimeOfDay now, TimeOfDay rem) {
  if (toDateTime(now).isBefore(toDateTime(rem))) return true;
  return false;
}

DateTime toDateTime(TimeOfDay time) {
  DateTime now = DateTime.now();
  DateTime dateTime =
      DateTime(now.year, now.month, now.day, time.hour, time.minute);
  return dateTime;
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;
