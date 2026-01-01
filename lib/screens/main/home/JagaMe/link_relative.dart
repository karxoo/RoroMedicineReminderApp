import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../../../../components/navBar.dart';
import '../../../../models/JagaMe.dart';
import '../../../../models/user.dart';
import '../../../../widgets/app_default.dart';

class LinkRelative extends StatefulWidget {
  const LinkRelative({Key? key}) : super(key: key);

  @override
  _LinkRelativeState createState() => _LinkRelativeState();
}

class _LinkRelativeState extends State<LinkRelative> {
  String userId = "";
  UserProfile userProfile = UserProfile("");
  bool relativesFound = true;
  getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userProfile = UserProfile(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('profile')
              .doc(userId)
              .collection('relatives')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> relativeCards = [];
              var data = snapshot.data!.docs;
              if (data != null) {
                if (data.length > 0) relativesFound = true;
                userProfile.getAllRelatives(data);
                for (var relative in userProfile.relatives) {
                  relativeCards.add(LinkCard(
                    relative: relative,
                    userID: userId,
                    documentID: relative?.documentID ?? ''
,
                    data: relative.toMap(),
                    recipients: [relative.phoneNumber ?? ''],
                  ));
                }
                return ListView(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Link Relatives',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Column(
                      children: relativeCards,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'Showing linked here does not mean that your accounts are linked . Please make sure that relative account is linked using the code sent . '),
                    )
                  ],
                );
              } else {
                relativesFound = false;
                return const Center(
                  child: Text('No relative Added.'),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    Key? key,
    required this.relative,
    required this.userID,
    required this.documentID,
    required this.data,
    required this.recipients,
  }) : super(key: key);

  final Relative relative;
  final String userID, documentID;
  final Map<String, dynamic> data;

  final List<String> recipients;

  @override
  Widget build(BuildContext context) {
    String buttonText = 'Link';
    Color buttonColor = Colors.orangeAccent;
    bool linked = false;
    linked = !(relative.uid?.isEmpty ?? true);
    buttonColor = linked ? Colors.blueGrey : Colors.grey;
    buttonText = linked ? 'Linked' : 'Link';
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.all(8),
        child: ListTile(
            title: Text(relative?.name ?? ''),
            subtitle: Text(relative?.phoneNumber ?? ''),
            trailing: ElevatedButton.icon(
               icon: const Icon(Icons.link), // required
                label: Text(buttonText),      // required
                onPressed: !linked
                    ? () async {
                        data['uid'] = userID;

                        recipients.add(relative?.phoneNumber ?? '');
                        await _sendSMS(
                            'Message from RORO : Please copy the below code to link your account.\nCode : $userID',
                            recipients);
                        await FirebaseFirestore.instance
                            .collection('profile')
                            .doc(userID)
                            .collection('relatives')
                            .doc(documentID)
                            .update(data);
                      }
                    : () async {
                        data['uid'] = '';
                        await FirebaseFirestore.instance
                            .collection('profile')
                            .doc(userID)
                            .collection('relatives')
                            .doc(documentID)
                            .update(data);
                      },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xffff9987), shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ))));
  }

  _sendSMS(String message, List<String> recipients) async {
    String result = await sendSMS(message: message, recipients: recipients)
        .catchError((onError) {
      print(onError);
    });

    print(result);
  }
}
