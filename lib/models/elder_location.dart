import 'package:roro_medicine_reminder/models/location.dart';
import '../services/constants.dart';
import '../services/network.dart';

class ElderLocation {
  late String address, url;
  late UserLocation location;
  ElderLocation();
  getLocationData() async {
    location = UserLocation(longitude: 0, latitude: 0);
    await location.getLocation().then((value) {
      location = value;
    });
    String uri =
        'https://api.opencagedata.com/geocode/v1/json?q=${location.latitude}+${location.longitude}&key=$kOpenCageApiKey';
    NetworkHelper networkHelper = NetworkHelper(uri);
    var data;
    await networkHelper.getData().then((value) {
      data = value;
    });
    url = data['results'][0]['annotations']['OSM']['url'];
    address = data['results'][0]['formatted'];
    return this;
  }
}
