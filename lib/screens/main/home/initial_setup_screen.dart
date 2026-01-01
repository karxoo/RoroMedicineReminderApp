import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// replaced rich_alert dialog with standard AlertDialog
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';

class InitialSetupScreen extends StatefulWidget {
  static const String routeName = 'Initial_Screen';

  const InitialSetupScreen({Key? key}) : super(key: key);
  @override
  _InitialSetupScreenState createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  bool isCompleted = false;
  final userNameController = TextEditingController();
  final relative1Controller = TextEditingController();
  final relative2Controller = TextEditingController();
  final relative1NumController = TextEditingController();
  final relative2NumController = TextEditingController();
  final fireStoreDatabase = FirebaseFirestore.instance;

  String userName = '';
  String relative1name = '';
  String relative2name = '';
  String relative1num = '';
  String relative2num = '';
  int age = 0;
  int gender = 0;
  String genderValue = '';

  @override
  void dispose() {
    userNameController.dispose();
    relative1Controller.dispose();
    relative2Controller.dispose();
    relative2NumController.dispose();
    relative1NumController.dispose();
    super.dispose();
  }

  User? loggedInUser;
  String email = '';
  String userId = '';

  void getCurrentUser() async {
  try {
    final User? user = auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      email = user?.email ?? '';   // safe assignment
      userId = user?.uid ?? '';          // uid is usually non-null
    }
  } catch (e) {
    print(e);
  }
}

  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Complete the Setup.'),
                  content: const Text('Please provide details to continue'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
          return await Future.value(false);
        },
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Text(
                  'Complete the Initial setup',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'The app requires you to give some data during this setup. Kindly enter all required data to all the fields below for best performance.',
                style:
                    TextStyle(fontWeight: FontWeight.w200, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('Name : ')),
                  Expanded(
                    flex: 6,
                    child: FormItem(
                      hintText: 'Enter  User Name',
                      controller: userNameController,
                      onChanged: (value) {
                        print('Name Saved');
                        setState(() {
                          userName = value;
                        });
                      },
                      isNumber: false,
                       icon: Icons.person, 
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
              child: Text(
                'Gender : ',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Male : '),
                  Radio(
                    onChanged: (value) {
                      setState(() {
                        gender = 'Male' as int;
                        genderValue = value as String;
                      });
                    },
                    activeColor: const Color(0xffE3952D),
                    value: 0,
                    groupValue: genderValue,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('Female : '),
                  Radio(
                    onChanged: (value) {
                      setState(() {
                        gender = 'Female' as int;
                        genderValue = value as String;
                      });
                    },
                    activeColor: const Color(0xffE3952D),
                    value: 1,
                    groupValue: genderValue,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text(' JagaMe \nName : ')),
                  Expanded(
                    flex: 6,
                    child: FormItem(
                      helperText: 'Name of the user',
                      hintText: 'Enter JagaMe Name',
                      controller: relative1Controller,
                      onChanged: (value) {
                        setState(() {
                          relative1name = value;
                        });
                      },
                      isNumber: false,
                       icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('JagaMe 1 : ')),
                  Expanded(
                    flex: 6,
                    child: FormItem(
                      hintText: 'Enter mobile Number ',
                      controller: relative1NumController,
                      onChanged: (value) {
                        setState(() {
                          relative1num = value;
                        });
                      },
                      isNumber: true,
                       icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 14, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text(' JagaMe \nName : ')),
                  Expanded(
                    flex: 6,
                    child: FormItem(
                      helperText: 'Name of the user',
                      hintText: 'Enter JagaMe Name',
                      controller: relative2Controller,
                      onChanged: (value) {
                        setState(() {
                          relative2name = value;
                        });
                      },
                      isNumber: false,
                       icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(child: Text('JagaMe 2 : ')),
                  Expanded(
                    flex: 6,
                    child: FormItem(
                      hintText: 'Enter mobile Number ',
                      controller: relative2NumController,
                      onChanged: (value) {
                        setState(() {
                          relative2num = value;
                        });
                      },
                      isNumber: true,
                       icon: Icons.person,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                await createRecord();
                setState(() {
                  initialSetupComplete = true;
                });

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const HomePage();
                }));
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(50, 20, 50, 30),
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 65.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.redAccent[100],
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.redAccent,
                      blurRadius: 3.0,
                      offset: Offset(0, 4.0),
                    ),
                  ],
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  Future createRecord() async {
    await fireStoreDatabase.collection("profile").doc(userId).set({
      'userName': userName,
      'email': email,
      'userId': userId,
      'height': 0,
      'weight': 0,
      'age': 0,
      'gender': genderValue,
      'bloodGroup': 'Not Set',
      'allergies': 'Not Set',
      'relative1number': relative1num,
      'relative1name': relative1name,
      'relative2number': relative2num,
      'relative2name': relative2name,
      'bloodSugar': 'Not set',
      'bloodPressure': 'Not set',
    });

//    DocumentReference ref = await fireStoreDatabase.collection("books").add({
//      'title': 'Flutter in Action',
//      'description': 'Complete Programming Guide to learn Flutter'
//    });
  }
}

bool initialSetupComplete = false;

class TextInputField extends StatelessWidget {
  var editingController = TextEditingController();
  final String helperText;
  final String hintText;
   final void Function(String) valueGetter;
  IconData icon;

  TextInputField(
      {Key? key, 
      required this.editingController,
      required this.valueGetter,
      this.helperText = "",
      this.hintText = "",
      required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: editingController,
        style: const TextStyle(),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
          helperText: helperText,
          icon: Icon(icon, color: Colors.blueGrey),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:
                  const BorderSide(color: Colors.indigo, style: BorderStyle.solid)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: Color(0xffaf5676), style: BorderStyle.solid)),
        ),
        onChanged: valueGetter,
      ),
    );
  }
}
