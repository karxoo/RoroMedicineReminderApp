
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// replaced rich_alert dialog with standard AlertDialog
import 'package:roro_medicine_reminder/screens/main/home/JagaMe/edit_relatives.dart';
import '../../../../components/navBar.dart';
import '../../../../models/elder_location.dart';
import '../../../../models/user.dart';
import '../../../../widgets/app_default.dart';



class ContactScreen extends StatefulWidget {
  static const String routeName = 'Contact_Screen';

  const ContactScreen({Key? key}) : super(key: key);
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ElderLocation elderLocation = ElderLocation();
  String messageText = '', username = 'user';
  String? userId;
  bool relativesFound = false;
  late UserProfile userProfile;
  List<String> recipients = [];

  @override
  void initState() {
    super.initState();
    recipients = [];
    getCurrentUser();
    elderLocation = ElderLocation();
    getLocationDetails();
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
    }
  }

   Future<ElderLocation> getLocationDetails() async {
    await elderLocation.getLocationData();
    setState(() {
      messageText =
          'Hey, this is $username. Find me at ${elderLocation.address}.\nLink to my location: ${elderLocation.url}';
    });
    return elderLocation;
  }

  Future<void> _sendSMS(String message, List<String> recipients) async {
    try {
      String result = await sendSMS(message: message, recipients: recipients);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: const ROROAppBar(),
        body: ListView(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('profile')
                    .doc(userId)
                    .collection('relatives')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> relativesWidget = [];
                    recipients = [];
                    var data = snapshot.data!.docs;
                    if (data != null) {
                      userProfile.getAllRelatives(data);
                      if (data.length > 0) relativesFound = true;
                      for (var relative in userProfile.relatives) {
                        recipients.add(relative?.phoneNumber ?? '');
                        relativesWidget.add(RelativeDetail(
                          name: relative?.name ?? '',
                          email: relative?.email ?? '',
                          number: relative?.phoneNumber ?? '',
                          documentID: relative?.documentID ?? '',
                          userId: userId ?? "",
                        ));
                      }

                      relativesWidget.add(Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.group_add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Add Relative',
                              style:
                              TextStyle(color: Colors.white, fontSize: 19),
                            ),
                            onPressed: () async {
                              Map<String, dynamic> dataMap = {
                                'name': '',
                                'email': '',
                                'phoneNumber': '',
                                'uid': ''
                              };
                              var ref = await FirebaseFirestore.instance
                                  .collection('profile')
                                  .doc(userId)
                                  .collection('relatives')
                                  .add(dataMap);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditRelativesScreen(ref.id);
                              }));
                            },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffff9987),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 40),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),

                          ))));
                      relativesWidget.add(const SizedBox(
                        height: 10,
                      ));
                    } else {
                      relativesFound = false;
                      relativesWidget.add(Center(
                        child: Container(
                          decoration: const BoxDecoration(),
                          margin: const EdgeInsets.all(20),
                          child: Column(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: Text('No relatives added.'),
                              ),
                              ElevatedButton.icon(
                                  icon: const Icon(
                                    Icons.group_add,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    'Add Relative',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 19)),
                                  onPressed: () async {
                                    Map<String, dynamic> dataMap = {
                                      'name': '',
                                      'email': '',
                                      'phoneNumber': '',
                                      'uid': ''
                                    };
                                    var ref = await FirebaseFirestore.instance
                                        .collection('profile')
                                        .doc(userId)
                                        .collection('relatives')
                                        .add(dataMap);

                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return EditRelativesScreen(
                                          ref.id);
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffff9987),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),

                                  ))
                            ],
                          ),
                        ),
                      ));
                    }

                    return Column(
                      children: <Widget>[
                        Center(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: const Text(
                              'JagaMe Details',
                              style: TextStyle(
                                fontSize: 32,
                                fontFamily: 'Mulish',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: relativesWidget,
                        ),
                        FutureBuilder<ElderLocation>(
                        future: getLocationDetails(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            ElderLocation elderLocation = snapshot.data!;
                            if (data.isEmpty) {
                              return const SizedBox();
                                }
                                return Center(
                                  child: GestureDetector(
                                    onTap: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Alert Relatives'),
                                              content: const Text('Are you sure?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    if (relativesFound) {
                                                      _sendSMS(messageText,
                                                          recipients);
                                                      print(messageText);
                                                    }
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
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 55.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.redAccent[100],
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red[100]!,
                                            blurRadius: 3.0,
                                            offset: const Offset(0, 4.0),
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        'Contact Relatives',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const LinearProgressIndicator();
                              }
                            }),
                      ],
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 50),
                      child: const SpinKitWanderingCubes(
                        color: Colors.blueGrey,
                        size: 100.0,
                      ),
                    );
                  }
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class RelativeDetail extends StatelessWidget {
  final String name, number, email, documentID, userId;

  const RelativeDetail(
      {Key? key, 
      this.name = "", 
      this.number = "", 
      this.email = "", 
      this.documentID = "", 
      this.userId = ""}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.red,
          ),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('profile')
                .doc(userId)
                .collection('relatives')
                .doc(documentID)
                .delete();
          },
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditRelativesScreen(documentID);
          }));
        },
        leading: Icon(
          Icons.person_pin,
          size: 45,
          color: Colors.blueGrey[700],
        ),
        contentPadding: const EdgeInsets.all(8),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(name),
        ),
        subtitle: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.phone,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text('Number : '),
                Expanded(child: Text(number)),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.email,
                  color: Colors.blueGrey,
                ),
                const SizedBox(
                  width: 8,
                ),
                const Text('Email : '),
                Expanded(child: Text(email))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
