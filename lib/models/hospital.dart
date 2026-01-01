

import '../services/constants.dart';
import '../services/network.dart';
import 'location.dart';

class HospitalData {
  late UserLocation userLocation;
  late List<Hospital> hospitalList;
  HospitalData();
  getNearbyHospital() async {
    hospitalList = [];
    userLocation = UserLocation();

    await userLocation.getLocation().then((value) {
      userLocation = value;
    });
    String url =
        'https://api.tomtom.com/search/2/nearbySearch/.JSON?key=$kTomsApiKey&lat=${userLocation.latitude}&lon=${userLocation.longitude}&radius=2000&limit=10&categorySet=7321';
    NetworkHelper networkHelper = NetworkHelper(url);
    var data;
    await networkHelper.getData().then((value) {
      data = value;
    });
    var hospitals = data['results'];
    hospitalList = [];
    for (var h in hospitals) {
      String locationUrl = '', placeName = '';
      double locationLat = h['position']['lat'];
      double locationLon = h['position']['lon'];
      String uri =
          'https://api.opencagedata.com/geocode/v1/json?q=$locationLat+$locationLon&key=f29cf18b10224e27b8931981380b747a';
      NetworkHelper networkHelper0 = NetworkHelper(uri);
      var data0 = await networkHelper0.getData();
      var hosData = data0['results'][0];
      placeName = hosData['components']['road'];
      locationUrl = hosData['annotations']['OSM']['url'];
      uri =
          'https://api.tomtom.com/routing/1/calculateRoute/${userLocation.latitude},${userLocation.longitude}:$locationLat,$locationLon/json?key=G5IOmgbhnBgevPJeglEK2zGJyYv6TG1Z';
      NetworkHelper network = NetworkHelper(uri);
      var distanceData = await network.getData();
      double hospitalDistance =
          distanceData['routes'][0]['summary']['lengthInMeters'] / 1000;

      Hospital hospital = Hospital(h['poi']['name'], h['position']['lat'],
          h['position']['lon'], locationUrl, placeName, hospitalDistance);

      try {
        hospitalList.add(hospital);
      } catch (e) {
        print(e);
      }
    }
    return this;
  }
}

class Hospital {
  String hospitalName;
  double hospitalLocationLatitude, hospitalLocationLongitude;
  String? hospitalLocationUrl, hospitalPlace;
  double? hospitalDistance;

  Hospital(
    this.hospitalName,
    this.hospitalLocationLatitude,
    this.hospitalLocationLongitude, [
    this.hospitalLocationUrl,
    this.hospitalPlace,
    this.hospitalDistance,
  ]);
}
