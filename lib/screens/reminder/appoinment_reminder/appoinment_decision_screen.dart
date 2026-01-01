
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';
import 'package:http/http.dart' as http;
import '../../../components/navBar.dart';
import '../../../models/appoinment.dart';
import '../../../services/database_helper.dart';

class AppoinmentDecision extends StatefulWidget {
  static const String routeName = 'Appoinment_decision_screen';
  final Appoinment appoinment;
  const AppoinmentDecision(this.appoinment, {Key? key}) : super(key: key);
  @override
  _AppoinmentDecisionState createState() => _AppoinmentDecisionState();
}

class _AppoinmentDecisionState extends State<AppoinmentDecision> {
  Future<void> sendSms() async {
    var cred =
        'AC07a649c710761cf3a0e6b96048accf58:60cfd08bcc74ea581187a048dfd653cb';

    var bytes = utf8.encode(cred);

    var base64Str = base64.encode(bytes);

    var url =
        'https://api.twilio.com/2010-04-01/Accounts/AC07a649c710761cf3a0e6b96048accf58/Messages.json';

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Basic $base64Str'
        }, body: {
          'From': '+12567403927',
          'To': '+918078214942',
          'Body': 'Just missed their appointment!'
        });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  DatabaseHelper helper = DatabaseHelper();
  late Appoinment appoinment;
  @override
  void initState() {
    appoinment = widget.appoinment;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Did you visit ${appoinment.name}',
                style: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      appoinment.done = true;
                      await helper.updateAppoinment(appoinment);
                      if (!mounted) return;
                      setState(() {});
                      navigator.pop();
                    },
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.check,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      appoinment.done = false;
                      await helper.updateAppoinment(appoinment);
                      if (!mounted) return;
                      setState(() {});
                      await sendSms();
                      navigator.pop();
                    },
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.red,
                      child: Icon(
                        Icons.close,
                        size: 90,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'If you don\'t respond within 15 minutes information will be sent to your JagaMe.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
