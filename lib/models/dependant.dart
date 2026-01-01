import 'JagaMe.dart';

class DependantProfile {
  String dependantUid;
  String? dAllergies;
  String? dUserName;
  int? dAge;
  String? dGender;
  String? dBloodGroup;
  String? dBloodPressure;
  String? dBloodSugar;
  double? dHeight;
  double? dWeight;
  String? dPhoneNumber;
  String? dPicture;

  List<Relative> relatives = [];

  DependantProfile(this.dependantUid);

  DependantProfile.fromMap(Map<String, dynamic> data)
      : dependantUid = data['uidD'],
        dPhoneNumber = data['phoneNumberD'],
        dAge = data['ageD'],
        dBloodGroup = data['bloodGroupD'],
        dBloodPressure = data['bloodPressureD'],
        dBloodSugar = data['bloodSugarD'],
        dGender = data['genderD'],
        dHeight = data['heightD'],
        dPicture = data['pictureD'],
        dWeight = data['weightD'],
        dUserName = data['userNameD'],
        dAllergies = data['allergiesD'];

  void getAllRelatives(List<Map<String, dynamic>> data) {
    relatives = data.map((relData) {
      final relative = Relative();
      relative.getData(relData);
      return relative;
    }).toList();
  }

  void deleteRelative(String documentID) {
    relatives.removeWhere((r) => r.documentID == documentID);
  }
}
