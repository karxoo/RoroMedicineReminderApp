import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../components/navBar.dart';
import '../../../models/reminder.dart';
import '../../../services/database_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MedicineDecisionScreen extends StatefulWidget {
  static const String routeName = 'Medicine_decision_screen';
  final Reminder reminder;
  const MedicineDecisionScreen(this.reminder, {Key? key}) : super(key: key);
  @override
  _MedicineDecisionScreenState createState() => _MedicineDecisionScreenState();
}

class _MedicineDecisionScreenState extends State<MedicineDecisionScreen> {
  Future<void> sendSms() async {
    final accountSid = dotenv.env['TWILIO_ACCOUNT_SID'];
    final authToken = dotenv.env['TWILIO_AUTH_TOKEN'];
    final fromNumber = dotenv.env['TWILIO_FROM'];

    if (accountSid == null || authToken == null || fromNumber == null) {
      debugPrint('Twilio credentials not found');
      return;
    }

    final cred = '$accountSid:$authToken';
    final base64Str = base64.encode(utf8.encode(cred));

    final url =
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Basic $base64Str',
      },
      body: {
        'From': fromNumber,
        'To': '+918078214942',
        'Body': 'Just missed their appointment!',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Did you take ${widget.reminder.name} ?',
                style: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          size: 90,
                          color: Colors.white,
                        )),
                    onTap: () {
                      Reminder r = widget.reminder;
                      DateTime now = DateTime.now();

                      String dateString =
                          (DateFormat('yyyy-MM-dd hh:mm').format(now));

                      r.intakeHistory ??= {}; // initialize if null

                      r.intakeHistory![dateString] = {
                        TimeOfDay.now().toString(): true,
                      };

                      databaseHelper.updateReminder(r);
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.close,
                          size: 90,
                          color: Colors.white,
                        )),
                    onTap: () async {
                      Reminder r = widget.reminder;
                      DateTime now = DateTime.now();

                      String dateString =
                          (DateFormat('yyyy-MM-dd hh:mm').format(now));

                      r.intakeHistory ??= {}; // initialize if null

                      r.intakeHistory![dateString] = {
                        TimeOfDay.now().toString(): true,
                      };

                      print(r.intakeHistory);
                      databaseHelper.updateReminder(r);
                      setState(() {});
                      final navigator = Navigator.of(context);
                      await sendSms();
                      if (!mounted) return;
                      navigator.pop();
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    'If you dont respond within 15 minutes information will be sent to your JagaMe.'))
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
