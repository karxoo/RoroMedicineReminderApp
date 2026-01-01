import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// replaced rich_alert dialog with standard AlertDialog

import '../../../components/navBar.dart';
import '../../../models/appoinment.dart';
import '../../../services/database_helper.dart';
import '../../../services/notifications.dart';
import '../../../widgets/app_default.dart';

class AppoinmentDetail extends StatefulWidget {
  static const String routeName = 'Appoinment_Detail_Screen';
  final String? pageTitle;
  final Appoinment appoinment;

  const AppoinmentDetail(this.appoinment, [this.pageTitle]);

  @override
  State<StatefulWidget> createState() {
    return _AppoinmentDetailState(appoinment, pageTitle);
  }
}

class _AppoinmentDetailState extends State<AppoinmentDetail> {
  final auth = FirebaseAuth.instance;
  User? loggedInUser;

  DatabaseHelper helper = DatabaseHelper();
  late Appoinment appoinment;
  String? pageTitle;
  var rng = Random();
  _AppoinmentDetailState(this.appoinment, this.pageTitle);
  int? notificationID;
  String doctorName = '', place = '', address = '';
  late DateTime date, dateCheck, tempDate;
  late TimeOfDay timeSelected;
  NotificationService? notificationService;
  TextEditingController nameController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController addressController = TextEditingController(text: '');
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final f = DateFormat('yyyy-MM-dd hh:mm');
  DateTime? newDate;
  @override
  void dispose() {
    nameController.dispose();
    placeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final User? user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  void initState() {
    doctorName = nameController.text = appoinment.name ?? '';
    place = placeController.text = appoinment.place ?? '';
    address = addressController.text = appoinment.address ?? '';
    date = dateCheck =
        DateTime.parse(appoinment.dateAndTime ?? DateTime.now().toString());
    tempDate = DateTime(date.year, date.month, date.day);
    timeSelected = TimeOfDay(hour: date.hour, minute: date.minute);
    notificationID = appoinment.notificationId;
    notificationService = NotificationService();
    notificationService?.initialize();
    super.initState();
  }

  Future _selectDate() async {
    final ctx = context;
    DateTime? picked = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() => tempDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          if (appoinment !=
              Appoinment(doctorName, place, date.toString(), address,
                  notificationID, false)) {
            final shouldPop = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Reminder Not Saved'),
                    content: const Text('Changes will be discarded'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                      ),
                    ],
                  );
                });
            return shouldPop ?? false;
          } else {
            return true;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    '$pageTitle Appoinment',
                    style: const TextStyle(
                        fontFamily: 'Mulish',
                        color: Colors.black,
                        fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              AppoinmentFormItem(
                helperText: 'Full name',
                hintText: 'Enter name of the Doctor',
                controller: nameController,
                onChanged: (value) {
                  setState(() {
                    doctorName = value;
                  });
                },
                isNumber: false,
                icon: FontAwesomeIcons.userDoctor,
              ),
              const SizedBox(
                height: 8,
              ),
              AppoinmentFormItem(
                helperText: 'Hospital , Home',
                hintText: 'Enter place of Visit',
                controller: placeController,
                onChanged: (value) {
                  setState(() {
                    place = value;
                  });
                },
                isNumber: false,
                icon: FontAwesomeIcons.houseChimneyMedical,
              ),
              const SizedBox(
                height: 8,
              ),
              AppoinmentFormItem(
                helperText: 'Any Specialization',
                hintText: 'Enter type ',
                controller: addressController,
                onChanged: (value) {
                  setState(() {
                    address = value;
                  });
                },
                isNumber: false,
                icon: FontAwesomeIcons.briefcaseMedical,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Date',
                          style: TextStyle(color: Colors.teal),
                        ),
                        InkWell(
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blueGrey,
                            child: Icon(
                              Icons.event_note,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          onTap: () async {
                            await _selectDate();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Time',
                          style: TextStyle(color: Colors.teal),
                        ),
                        InkWell(
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(
                                Icons.alarm_add,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              final ctx = context;
                              final pickedTime = await showTimePicker(
                                context: ctx,
                                initialTime: TimeOfDay.now(),
                              );
                              if (pickedTime == null) return;
                              if (!mounted) return;
                              setState(() {
                                timeSelected = pickedTime;
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Column(
                children: <Widget>[
                  Text('Date :  ${tempDate.toString().substring(0, 10)}'),
                  Text('Time :  ${timeSelected.format(context)}')
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 16, 18, 1),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: const Color(0xffff9987),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.redAccent[100]!,
                        )),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                  ),
                  label: const Text('Save'),
                  icon: const Icon(Icons.save),
                  onPressed: () async {
                    if (!(timeSelected.minute == 0 && timeSelected.hour == 0)) {
                      if (!(tempDate.year == 0 &&
                          tempDate.month == 0 &&
                          tempDate.day == 0)) {
                        if (!mounted) return;
                        setState(() {
                          date = DateTime(
                              tempDate.year,
                              tempDate.month,
                              tempDate.day,
                              timeSelected.hour,
                              timeSelected.minute);
                        });

                        await _save();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  // Save data to database
  Future<void> _save() async {
    final navigator = Navigator.of(context);
    final ctx = context;
    appoinment.dateAndTime = f.format(date);
    appoinment.name = doctorName;
    appoinment.address = address;
    appoinment.place = place;

    int result;
    if (appoinment.id != null) {
      // Case 1: Update operation
      result = await helper.updateAppoinment(appoinment);
    } else {
      // Case 2: Insert Operation
      appoinment.notificationId = rng.nextInt(9999);
      result = await helper.insertAppoinment(appoinment);
      if (date.isAfter(DateTime.now())) {
    if (appoinment.notificationId != null) {
      notificationService?.scheduleAppoinmentNotification(
        id: appoinment.notificationId!, // safe because we checked
        title: appoinment.name ?? 'No name',
        body: '${appoinment.place ?? ''} ${appoinment.address ?? ''}',
        dateTime: date,
      );
    }
  }

    }
    if (date != dateCheck) {
      if (appoinment.notificationId != null) {
    notificationService?.removeReminder(appoinment.notificationId!);

    if (date.isAfter(DateTime.now())) {
      notificationService?.scheduleAppoinmentNotification(
        id: appoinment.notificationId!,
        title: appoinment.name ?? 'No name',
        body: '${appoinment.place ?? ''} ${appoinment.address ?? ''}',
        dateTime: date,
      );
    }
  }

    }
    if (!mounted) return;
    if (result != 0) {
      // Success
      _showAlertDialog(ctx, 'Status', 'Successfully recorded!');
      navigator.pop();
    } else {
      // Failure
      _showAlertDialog(ctx, 'Status', 'Problem Saving Appoinment');
    }
  }

  void _showAlertDialog(BuildContext ctx, String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: ctx, builder: (_) => alertDialog);
  }
}

class AppoinmentFormItem extends StatelessWidget {
  final String? hintText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final bool isNumber;
  final IconData? icon;
  final TextEditingController? controller;

  const AppoinmentFormItem(
      {Key? key,
      this.hintText,
      this.helperText,
      this.onChanged,
      this.icon,
      this.isNumber = false,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 7, 10, 7),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: Colors.indigo, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
        ),
        onChanged: (value) => onChanged?.call(value), 
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}
