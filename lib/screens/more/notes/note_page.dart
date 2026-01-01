import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:roro_medicine_reminder/screens/more/notes/notes.dart';
import 'package:roro_medicine_reminder/screens/more/notes/view_note.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';
import '../../../widgets/home_screen_widgets.dart';

class NotePage extends StatefulWidget {
  static const String routeName = 'Note_screen';

  const NotePage({Key? key}) : super(key: key);
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  CollectionReference? ref;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      ref = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('notes');
    }
  }

  List<Color?> myColors = [
    Colors.yellow[200],
    Colors.red[200],
    Colors.green[200],
    Colors.deepPurple[200],
    Colors.purple[200],
    Colors.cyan[200],
    Colors.teal[200],
    Colors.tealAccent[200],
    Colors.pink[200],
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (ref == null) {
      return Scaffold(
        appBar: const ROROAppBar(),
        drawer: const AppDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not signed in.'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/SignInPage');
                },
                child: const Text('Sign In'),
              )
            ],
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(),
      );
    }

    return Scaffold(
      appBar: const ROROAppBar(),
      drawer: const AppDrawer(),
      body: FutureBuilder<QuerySnapshot>(
        future: ref?.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const AddNote();
                              //return ReminderDetail();
                            }));
                          },
                        ),
                        const Center(
                          //margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                          child: Text(
                            'You have no saved notes! \nClick to add one.',
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
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Random random = Random();
                final bg =
                    myColors[random.nextInt(myColors.length)] ?? Colors.white;
                final data = docs[index].data() as Map<String, dynamic>;
                final mydateTime = (data['created'] as dynamic).toDate();
                final formattedTime =
                    DateFormat.yMMMd().add_jm().format(mydateTime);

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ViewNote(
                          data,
                          formattedTime,
                          docs[index].reference,
                        ),
                      ),
                    )
                        .then((value) {
                      if (mounted) setState(() {});
                    });
                  },
                  child: Card(
                    color: bg,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['title']}",
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontFamily: "Mulish",
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
