import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/app_default.dart';

class Inventory extends StatelessWidget {
  static const routeName = '/inventory';

  const Inventory({Key? key}) : super(key: key);

  Future<void> _refreshMeds(BuildContext context) async {
    // await Provider.of<MedicineList>(context, listen: false)
    //.fetchAndSetMedicines();
  }

  @override
  Widget build(BuildContext context) {
    //final medlist = Provider.of<MedicineList>(context);
    //final medicines = medlist.items;
    return RefreshIndicator(
      onRefresh: () => _refreshMeds(context),
      child: Scaffold(
        appBar: const ROROAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Medicine Name',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quantity',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Expanded(
                 child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('medicines') // 👈 your Firestore collection
                      .snapshots(),
            builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          return ListTile(
                            title: Text(doc['title'] ?? 'Untitled'),
                            subtitle: Text(doc['description'] ?? ''),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error loading data"));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
