

import 'package:flutter/material.dart';
import 'package:roro_medicine_reminder/screens/more/extraInfo.dart';
import 'package:roro_medicine_reminder/screens/more/help%20n%20support/helpnsupport.dart';
import 'package:line_icons/line_icons.dart';

import 'package:roro_medicine_reminder/screens/more/trackers/health_tracker.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../components/navBar.dart';
import '../more/about.dart';
import '../more/notes/note_page.dart';
import '../reminder/appoinment_reminder/appoinment_reminder_screen.dart';
import 'Settings/settings.dart';

class More extends StatefulWidget {
  const More({Key? key}) : super(key: key);

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  int index = 0;
  final items = List.generate(2000, (counter) => 'Item: $counter');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "RORO",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.blueGrey,
            actions: [IconButton(
                icon: const Icon(Icons.settings),
                onPressed: ()  {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => const SettingsPage()));
                }
            ),
            ],
        ),
        drawer: const AppDrawer(),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('Notes',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              //subtitle: Text('Add notes.'),
              trailing: const Icon(Icons.note_add, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotePage()),
                )
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('Health Tracker',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(LineIcons.heartbeat, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrackerHome()),
                )
            ),
            /*ListTile(
              leading: Icon(Icons.arrow_forward_ios),
              title: Text('Refills',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: Icon(LineIcons.prescription, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddInventoryScreen()),
                )
            ),*/
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('Appointments',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(LineIcons.calendarWithDayFocus, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppoinmentReminder()),
                )
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('Additional Info',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.info_outline, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExtraInfo()),
                )
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('Help & Support',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.live_help_outlined, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const helpSupport()),
                )
            ),
            ListTile(
              leading: const Icon(Icons.arrow_forward_ios),
              title: const Text('About',
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
              trailing: const Icon(LineIcons.shapes, color: Colors.blueGrey),
              onTap: () =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const About()),
                )
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}


