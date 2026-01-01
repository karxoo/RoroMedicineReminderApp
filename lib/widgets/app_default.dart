import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// replaced rich_alert dialog with standard AlertDialog
import '../main.dart';
import '../screens/main/home/JagaMe/contact_relatives_screen.dart';
import '../screens/main/home/JagaMe/link_relative.dart';
import '../screens/main/home/profile/profile_screen.dart';
import '../services/auth.dart';

final auth = FirebaseAuth.instance;
AuthClass authClass = AuthClass();
Future<User?> getUser() async {
  return auth.currentUser;
}

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? userId;
  String imageUrl = '';
  User? loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
        loggedInUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Drawer(
          child: ListView(children: <Widget>[
        Container(
          height: 50.0,
          color: const Color(0xffe3f1f4),
        ),
        const CircleAvatar(
            radius: 60.0,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(
                "https://platform-static-files.s3.amazonaws.com/premierleague/photos/players/250x250/Photo-Missing.png/150")),
        const Text(
          'Hello there!',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, fontFamily: "Mulish"),
        ),
        Container(
          child: const Column(
            children: <Widget>[
              Text(''),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListTile(
                leading: const Icon(
                  Icons.favorite_outline_sharp,
                ),
                title: const Text('Invite JagaMe',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: "Mulish")),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LinkRelative()),
                    )),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
              ),
              title: const Text('Sign Out',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: "Mulish")),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Log out from the App'),
                        content: const Text('Are you sure?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Yes'),
                            onPressed: () async {
                              final navigator = Navigator.of(context);
                              await authClass.signOut();
                              navigator.pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (builder) => MyApp()),
                                  (route) => false);
                            },
                          ),
                          TextButton(
                            child: const Text('No'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        )
      ])),
    );
  }
}

class ListButtons extends StatelessWidget {
  final String text;
  final icon;
  final onTap;

  const ListButtons({Key? key, 
  this.text = "", 
  required this.icon, 
  required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 6),
      child: InkWell(
        splashColor: const Color(0xffba6abc3),
        onTap: onTap,
        focusColor: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              text,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: Icon(
              icon,
              size: 25,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class FormItem extends StatelessWidget {
  final String hintText;
  final String helperText;
  final Function onChanged;
  final bool isNumber;
  final IconData icon;
  final controller;

  const FormItem(
      {Key? key, 
      this.hintText = "",
      this.helperText = "",
      required this.onChanged,
      required this.icon,
      this.isNumber = false,
      this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.all(5),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Colors.redAccent[100]!, style: BorderStyle.solid)),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Colors.redAccent[100]!, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Colors.redAccent[100]!, style: BorderStyle.solid)),
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

class ROROAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 56;

  const ROROAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
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
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blueGrey,
             child: Icon(
      Icons.perm_identity,
      size: 30,
      color: Colors.white,
    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
