import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_time_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
// replaced rich_alert dialog with standard AlertDialog
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../components/navBar.dart';
import '../../../models/reminder.dart';
import '../../../services/database_helper.dart';

import '../../../services/notifications.dart';
import 'medicine_reminder.dart';

class ReminderFormItem extends StatelessWidget {
  final String hintText;
  final String helperText;
  final Function onChanged;
  final bool isNumber;
  final IconData icon;
  final controller;

  const ReminderFormItem(
      {Key? key,
      this.hintText = '',
      this.helperText = '',
      required this.onChanged,
      required this.icon,
      this.isNumber = false,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: TextField(
        maxLines: 1,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
          prefixIcon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Colors.indigo, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
        ),
        onChanged: (String value) {
          onChanged(value);
        },
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      ),
    );
  }
}

class ReminderDetail extends StatefulWidget {
  static const String routeName = 'Medicine_detail_screen';

  final String pageTitle;
  final Reminder reminder;

  const ReminderDetail(this.reminder, [this.pageTitle = '']);

  @override
  State<StatefulWidget> createState() {
    return _ReminderDetailState(reminder, pageTitle);
  }
}

class _ReminderDetailState extends State<ReminderDetail> {
  final auth = FirebaseAuth.instance;
  User? loggedInUser;

  DatabaseHelper helper = DatabaseHelper();
  late Reminder reminder, tempReminder;
  String? pageTitle;
  var rng = Random();
  NotificationService? notificationService;

  late String tempTime1, tempTime2, tempTime3;
  late List<String> timeStringList;
  _ReminderDetailState(this.reminder, this.pageTitle);

  late TimeOfDay selectedTime1, selectedTime2, selectedTime3, t1, t2, t3;
  TimeOfDay timeNow = TimeOfDay.now();

  int times = 2;

  String medicineName = '';
  String? tempName;
  String medicineType = '';
  Map<String, dynamic>? intakeHistory;
  File? pickedImage;
  bool isImageLoaded = false;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) return;
    setState(() {
      pickedImage = File(pickedFile.path);
      isImageLoaded = true;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
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
    tempReminder = widget.reminder;
    reminder = widget.reminder;
    medicineName = nameController.text = reminder.name ?? '';
    medicineType = typeController.text = reminder.type ?? '';
    times = reminder.times ?? 1;

    tempTime1 = reminder.time1 ?? '00:00';
    intakeHistory = reminder.intakeHistory ?? {};
    tempTime2 = reminder.time2 ?? '00:00';

    tempTime3 = reminder.time3 ?? '00:00';
    selectedTime1 = t1 = _parseTimeOrDefault(tempTime1);
    selectedTime2 = t2 = _parseTimeOrDefault(tempTime2);
    selectedTime3 = t3 = _parseTimeOrDefault(tempTime3);
    super.initState();
    notificationService = NotificationService();
    notificationService?.initialize();
  }

  TimeOfDay _parseTimeOrDefault(String? s) {
    if (s == null || !s.contains(':'))
      return const TimeOfDay(hour: 0, minute: 0);
    final parts = s.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  final nameController = TextEditingController();
  final typeController = TextEditingController();

  Future readText() async {
    setState(() {
      nameController.value = const TextEditingValue(text: '');
      nameController.text = '';
      medicineName = '';
      tempName = null;
      isImageLoaded = false;
    });

    if (pickedImage != null) {
      final googleVisionImage = GoogleVisionImage.fromFile(pickedImage!);

      final TextRecognizer recognizeText =
          GoogleVision.instance.textRecognizer();
      final VisionText readText =
          await recognizeText.processImage(googleVisionImage);

      for (TextBlock block in readText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement word in line.elements) {
            tempName = word.text;
          }
        }
      }

      setState(() {
        if (medicineName.isEmpty) {
          medicineName = tempName ?? '';
          nameController.text = medicineName;
        } else {
          medicineName = '';
          nameController.clear();
          isImageLoaded = false;
          tempName = '';
        }
      });
    }
  }

// Show alert dialog
  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Save data to database
  Future<void> _save() async {
    final navigator = Navigator.of(context);
    int result;

    if (reminder.id != null) {
      result = await helper.updateReminder(reminder);
      // ... your update logic
    } else {
      reminder.notificationID = rng.nextInt(9999);
      result = await helper.insertReminder(reminder);
      // ... your insert logic
    }

    if (!context.mounted) return; // ✅ Fix for async context usage

    if (result != 0) {
      _showAlertDialog('Status', 'Reminder Saved Successfully');
      await navigator.push(MaterialPageRoute(builder: (context) {
        return MedicineReminder(reminder: reminder);
      }));
      navigator.pop();
    } else {
      _showAlertDialog('Status', 'Problem Saving Reminder');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          if (reminder !=
              Reminder(
                  medicineName,
                  medicineType,
                  selectedTime1.toString(),
                  selectedTime2.toString(),
                  selectedTime3.toString(),
                  times,
                  reminder.notificationID,
                  intakeHistory)) {
            return (await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Reminder Not Saved'),
                        content: const Text('Changes will be discarded'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      );
                    })) ??
                false;
          } else {
            return true;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 30,
                      fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: ReminderFormItem(
                      helperText: 'Name of Reminder',
                      hintText: 'Enter Medicine Name',
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          medicineName = value.toString();
                        });
                      },
                      isNumber: false,
                      icon: FontAwesomeIcons.capsules,
                    ),
                  ),
                  Expanded(
                    child: Tooltip(
                      message: 'Detect Name from Image',
                      child: GestureDetector(
                        child: Icon(
                          Icons.camera,
                          color: isImageLoaded
                              ? Colors.blue[100]
                              : Colors.blueGrey,
                          size: 43,
                        ),
                        onTap: () async {
                          await getImage();
                          nameController.clear();
                          medicineName = '';
                          await readText();
                        },
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ReminderFormItem(
                helperText: 'Give the type for reference',
                hintText: 'Enter type of medicine',
                controller: typeController,
                onChanged: (value) {
                  setState(() {
                    medicineType = value;
                  });
                },
                isNumber: false,
                icon: FontAwesomeIcons.prescriptionBottle,
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 10),
                child: Text(
                  'Times a day : ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Once : '),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          times = value as int;
                        });
                      },
                      activeColor: const Color(0xffff9987),
                      value: 1,
                      groupValue: times,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Twice : '),
                    Radio(
                      onChanged: (value) {
                        setState(() {
                          times = value as int;
                        });
                      },
                      activeColor: const Color(0xffff9987),
                      value: 2,
                      groupValue: times,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Thrice : '),
                    Radio(
                      activeColor: const Color(0xffff9987),
                      onChanged: (value) {
                        setState(() {
                          times = value as int;
                        });
                      },
                      value: 3,
                      groupValue: times,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  times == 1
                      ? const SizedBox(
                          width: 80,
                        )
                      : const SizedBox(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showMaterialTimePicker(
                          context: context,
                          selectedTime: selectedTime1,
                          onChanged: (value) =>
                              setState(() => selectedTime1 = value),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blueGrey,
                        child: Icon(
                          Icons.access_alarm,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  times >= 2
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showMaterialTimePicker(
                                context: context,
                                selectedTime: selectedTime2,
                                onChanged: (value) =>
                                    setState(() => selectedTime2 = value),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(
                                Icons.access_alarm,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  times == 3
                      ? Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showMaterialTimePicker(
                                context: context,
                                selectedTime: selectedTime3,
                                onChanged: (value) =>
                                    setState(() => selectedTime3 = value),
                              );
                            },
                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(
                                Icons.access_alarm,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  times == 1
                      ? const SizedBox(
                          width: 80,
                        )
                      : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  times >= 1 &&
                          selectedTime1 != const TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 1 :  ${selectedTime1.format(context)}')
                      : const SizedBox(),
                  times >= 2 &&
                          selectedTime2 != const TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 2 :  ${selectedTime2.format(context)}')
                      : const SizedBox(
                          height: 8,
                        ),
                  times == 3 &&
                          selectedTime3 != const TimeOfDay(hour: 0, minute: 0)
                      ? Text('Time 3 :  ${selectedTime3.format(context)}')
                      : const SizedBox(
                          height: 8,
                        ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: const Color(0xffff9987),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.redAccent[100]!,
                      )),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                ),
                label: const Text('Save'),
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (!mounted) return;
                  setState(() {
                    reminder.times = times;
                    reminder.name = medicineName;
                    reminder.type = medicineType;
                    if (times >= 1) {
                      reminder.time1 =
                          '${selectedTime1.hour}:${selectedTime1.minute}';
                    }
                    if (times >= 2) {
                      reminder.time2 =
                          '${selectedTime2.hour}:${selectedTime2.minute}';
                    } else {
                      reminder.time2 = '00:00';
                    }
                    if (times == 3) {
                      reminder.time3 =
                          '${selectedTime3.hour}:${selectedTime3.minute}';
                    } else {
                      reminder.time3 = '00:00';
                    }
                  });
                  await _save();
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
