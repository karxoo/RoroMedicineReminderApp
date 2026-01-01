import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roro_medicine_reminder/models/user.dart';
import 'package:roro_medicine_reminder/screens/main/home/homePage.dart';
import 'package:roro_medicine_reminder/screens/main/home/profile/ProfileTextBox.dart';
import 'package:roro_medicine_reminder/widgets/app_default.dart';

import '../../../../components/navBar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = 'Dependent_Profile_Screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<String> addProfile() async {
    CollectionReference profile =
        FirebaseFirestore.instance.collection('profile');
    var profiles = await profile.add({

    });
    return 'Created';
  }

  String userId = '';
  String imageUrl = '';
  User? loggedInUser;
  File? imageFile;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid ?? '';
      loggedInUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'RORO',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 1,
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('profile')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final doc = snapshot.data as DocumentSnapshot;
              final data = doc.data() as Map<String, dynamic>?;
              UserProfile userProfile = UserProfile(userId);
              userProfile.setData(data ?? <String, dynamic>{});
              final pictureUrl = userProfile.picture ?? '';
              return ListView(
                children: <Widget>[
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            border:
                              Border.all(width: 5, color: Colors.white),
                            borderRadius: BorderRadius.circular(2000),
                            shape: BoxShape.rectangle,
                            image: pictureUrl.isNotEmpty
                              ? DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(pictureUrl))
                              : null)),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await getImage();
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileTextBox(
                    name: 'userName',
                    value: userProfile?.userName ?? '',
                    title: 'name',
                  ),
                  ProfileTextBox(
                    name: 'age',
                    value: userProfile?.age ?? '',
                    title: 'age',
                  ),
                  ProfileTextBox(
                    name: 'gender',
                    value: userProfile?.gender ?? '',
                    title: 'gender',
                  ),
                  ProfileTextBox(
                    name: 'height',
                    value: userProfile?.height ?? '',
                    title: 'height',
                  ),
                  ProfileTextBox(
                    name: 'weight',
                    value: userProfile?.weight ?? '',
                    title: 'weight',
                  ),
                  ProfileTextBox(
                    name: 'bloodGroup',
                    value: userProfile?.bloodGroup ?? '',
                    title: 'blood group',
                  ),
                  ProfileTextBox(
                    name: 'bloodPressure',
                    value: userProfile?.bloodPressure ?? '',
                    title: 'blood pressure',
                  ),
                  ProfileTextBox(
                    name: 'bloodSugar',
                    value: userProfile?.bloodSugar ?? '',
                    title: 'blood sugar',
                  ),
                  ProfileTextBox(
                    name: 'allergies',
                    value: userProfile?.allergies ?? '',
                    title: 'allergies',
                  ),
                  ProfileTextBox(
                    name: 'email',
                    value: userProfile?.email ?? '',
                    title: 'email address',
                  ),
                  ProfileTextBox(
                    name: 'phoneNumber',
                    value: userProfile?.phoneNumber ?? '',
                    title: 'phone number',
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            updateData;
                            Navigator.pushNamed(
                                context, ProfileScreen.routeName);
                            debugPrint('Changed');
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2, backgroundColor: const Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100]!,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: const Text("Update Data",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2, backgroundColor: const Color(0xffff9987),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.redAccent[100]!,
                                )),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )
                      ]),
                ],
              );
            } else {
              return Container(
                child: const SpinKitWanderingCubes(
                  color: Colors.blueGrey,
                  size: 100.0,
                ),
              );
            }
          }),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  updateData(String name, String value) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(userId)
        .update({name: value});
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      imageFile = File(pickedFile.path);
    });
    setState(() {
//        isLoading = true;
    });
    await uploadFile(userId);
    }

  Future uploadFile(String name) async {
    String fileName = name;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;

      setState(() {
//        isLoading = false;
      });
      updateData('picture', imageUrl);
    }, onError: (err) {
      setState(() {
//        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return const Dialog(
              child: Text('Not an Image.'),
            );
          });
    });
  }
}
