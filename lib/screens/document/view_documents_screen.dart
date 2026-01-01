import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/image.dart';
import '../../widgets/app_default.dart';
import 'add_documents_screen.dart';
import 'document_detail_screen.dart';

class ViewDocuments extends StatefulWidget {
  static const String routeName = 'View_Documents_Screen';

  const ViewDocuments({Key? key}) : super(key: key);
  @override
  _ViewDocumentsState createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  late TextEditingController nameController;
  late String userId;

  @override
  void initState() {
    nameController = TextEditingController();
    getCurrentUser();
    super.initState();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('documents')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.data() != null) {
                      final images = ImageModel();
                      final allImages = images.getAllImages(
                          snapshot.data!.data() as Map<String, dynamic>);

                      List<ImageClass> displayList;
                      if (nameController.text.isEmpty) {
                        displayList = allImages;
                      } else {
                        displayList = images.searchImages(nameController.text);
                      }

                      final imageWidgets = addImages([], displayList);

                      return Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: const BoxDecoration(
                              color: Color(0xff42495D),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40),
                              ),
                            ),
                            child: TextField(
                              controller: nameController,
                              onSubmitted: (v) {
                                setState(() {});
                              },
                              onChanged: (v) {
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                suffixIcon: const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                hintText: 'Search for files',
                              ),
                            ),
                          ),
                          displayList.isNotEmpty
                              ? const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Documents',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Files not Found',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                          Column(children: imageWidgets),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading documents'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddDocuments.routeName);
        },
        elevation: 2,
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade200,
        elevation: 2,
        notchMargin: 2,
        shape: const CircularNotchedRectangle(),
        child: const SizedBox(
          height: 56,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('Upload Files'),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> addImages(List<Widget> imageWidgets, List<ImageClass> imageList) {
    for (var image in imageList) {
      imageWidgets.add(
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DocumentDetail(image);
            }));
          },
          child: Hero(
            tag: image.name ?? 'defaultTag',
            child: Container(
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(image.url ?? ''),
                ),
              ),
              child: SizedBox(
                width: 250,
                height: 250,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(99),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: 250,
                    height: 35,
                    child: Center(
                      child: Text(
                        image.name ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return imageWidgets;
  }

  Future<void> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user!.uid;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
