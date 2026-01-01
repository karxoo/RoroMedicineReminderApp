import 'package:flutter/material.dart';

import '../../../components/navBar.dart';
import '../../../main.dart';
import '../../../services/auth.dart';
import '../../../widgets/app_default.dart';
import '../../authenticate/forgotPwd.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontFamily: "Mulish", fontSize: 25, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 40,
            ),
            const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blueGrey,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(

                title: const Text('Change Password',
                    style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
                leading: const Icon(Icons.arrow_forward_ios),
                //subtitle: Text('Add notes.'),
                onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const forgotPwd()),
                    )
            ),
            /*ListTile(

                title: Text('Privacy and security',
                    style: TextStyle(fontFamily: "Mulish", fontSize: 18, fontWeight: FontWeight.bold)),
                leading: Icon(Icons.arrow_forward_ios),

                onTap: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => privacy()),
                    )
            ),*/

            const SizedBox(
              height: 50,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff9987),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  await authClass.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (builder) => MyApp()),
                          (route) => false);
                },
                child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontFamily: "Mulish", fontSize: 16, letterSpacing: 2.2, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }


  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontFamily: "Mulish",
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
