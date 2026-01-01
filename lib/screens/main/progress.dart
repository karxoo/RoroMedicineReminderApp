import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/navBar.dart';

import '../../services/auth.dart';
import '../../widgets/app_default.dart';


class Progress extends StatefulWidget {
  static const routeName = '/logbook';

  const Progress({Key? key}) : super(key: key);

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  AuthClass authClass = AuthClass();
  final _isLoading = false;
  @override


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        drawer: const AppDrawer(),
    appBar: const ROROAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: const Divider(
                    thickness: 3.0,
                    color: Colors.black45,
                    indent: 55.0,
                  ),
                ),
                Text(
                  DateFormat("dd/MM").format(DateTime.now()),
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ],
            ),
          ),
    ]),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
