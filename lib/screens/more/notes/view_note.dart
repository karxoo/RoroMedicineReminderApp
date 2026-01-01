import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../components/navBar.dart';
import '../../../widgets/app_default.dart';
import 'note_page.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  const ViewNote(this.data, this.time, this.ref, {Key? key}) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  String title = "";
  String des = "";

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
      child: Scaffold(
        //
        floatingActionButton: edit
            ? FloatingActionButton(
          onPressed: save,
          backgroundColor: Colors.blueGrey,
          child: const Icon(
            Icons.save_rounded,
            color: Colors.white,
          ),
        )
            : null,
        //
        resizeToAvoidBottomInset: false,
        //
        appBar: const ROROAppBar(),
        drawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                    ),
                    //
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.grey[700],
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 24.0,
                          ),
                        ),
                        //
                        const SizedBox(
                          width: 8.0,
                        ),
                        //
                        ElevatedButton(
                          onPressed: delete,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.red[300],
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 8.0,
                              ),
                            ),
                          ),
                          child: const Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                //
                const SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontFamily: "Mulish",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (val) {
                          title = val;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          widget.time,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Mulish",
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      //

                      TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontFamily: "Mulish",
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (val) {
                          des = val;
                        },
                        maxLines: 20,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(),
      ),
    );
  }

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  const NotePage()));
  }

  void save() async {
    if (key.currentState?.validate() ?? false) {
      // TODo : showing any kind of alert that new changes have been saved
      await widget.ref.update(
        {'title': title, 'description': des},
      );
      showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Your changes have been saved."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // close dialog
              Navigator.of(context).pop(); // close screen
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
    }
  }
}