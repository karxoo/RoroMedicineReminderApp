
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart' as LocationManager;

import '../../components/navBar.dart';
import '../../models/hospital.dart';
import '../../widgets/app_default.dart';

LocationManager.Location location = LocationManager.Location();

class NearbyHospitalScreen extends StatefulWidget {
  static const String routeName = 'Nearby_Hospital_screen';

  const NearbyHospitalScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NearbyHospitalScreenState();
  }
}

class NearbyHospitalScreenState extends State<NearbyHospitalScreen> {
  bool showSpinner = true;
  late HospitalData hospitalData;
  @override
  initState() {
    super.initState();
    hospitalData = HospitalData();
    hospitalData.getNearbyHospital();
  }

  late double lat, tempLon;
  late String locationUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const ROROAppBar(),
      body: FutureBuilder<HospitalData>(
        future: hospitalData.getNearbyHospital(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitChasingDots(
                    color: Colors.blueGrey,
                    size: 100.0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Fetching data . Please wait ..'),
                  ),
                  Text(' It may take a few moments .'),
                ],
              ),
            );
          } else {
      final data = snapshot.data!;
            return Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Nearby Hospitals',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                      itemCount: data.hospitalList.length,
                      itemBuilder: (context, index) {
                        if (index % 2 == 0) {
                          final hospital = data.hospitalList[index];
            final hosLon = hospital.hospitalLocationLongitude.toString();
            final hosLat = hospital.hospitalLocationLatitude.toString();

                          return Column(
                            children: <Widget>[
                              Card(
                                margin: const EdgeInsets.all(15),
                                color: Colors.white,
                                elevation: 2.5,
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.local_hospital,
                                        size: 40, color: Colors.red),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text('${                                           
                                            hospital.hospitalDistance} KM'),
                                  ),
                                  title: hospital.hospitalName !=
                                          null
                                      ? Text(
                                          hospital.hospitalName,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.blueGrey),
                                        )
                                      : const Text(''),
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        'https://www.google.com/maps/dir/${data.userLocation.latitude},${data.userLocation.longitude}/$hosLat,$hosLon'));
                                  },
                                ),
                              )
                            ],
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}
