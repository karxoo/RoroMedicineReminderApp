import 'package:flutter/material.dart';
import '../../components/navBar.dart';
import '../../services/auth.dart';
import '../../widgets/app_default.dart';
import '../reminder/measurement/measurement_screen.dart';
import '../reminder/medicine/medicine_reminder.dart';
import 'fab_menu.dart';

class Treatment extends StatefulWidget {
  const Treatment({Key? key}) : super(key: key);

  @override
  _TreatmentState createState() => _TreatmentState();
}

class _TreatmentState extends State<Treatment> {
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: Center(
        child: Container(
          child: const Text("Add your treatments here!"),
        ),
      ),
      floatingActionButton: ExpandableFab(
        initialOpen: false,
        distance: 60.0,
        children: [
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeasureScreen()),
              );
            },
            icon: const Icon(Icons.monitor_heart_sharp, color: Colors.blueGrey),
            tooltip: "Measure",
          ),
          ActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MedicineReminder(reminder: reminder!)),
              );
            },
            icon: const Icon(Icons.medication_liquid_outlined,
                color: Colors.blueGrey),
            tooltip: "Reminder",
          ),
        ],
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
