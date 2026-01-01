import 'JagaMe.dart';

class UserProfile {
  String? allergies,
      userName,
      age,
      gender,
      bloodGroup,
      bloodPressure,
      bloodSugar,
      email,
      height,
      weight,
      phoneNumber,
      picture,
      uid;
  List<Relative> relatives = [];
  UserProfile(this.uid);
  setData(Map<String, dynamic> data) {
    uid = data['uid'] as String?;
    phoneNumber = data['phoneNumber'] as String?;
    age = data['age'] as String?;
    bloodGroup = data['bloodGroup'] as String?;
    bloodPressure = data['bloodPressure'] as String?;
    bloodSugar = data['bloodSugar'] as String?;
    email = data['email'] as String?;
    gender = data['gender'] as String?;
    height = data['height'] as String?;
    picture = data['picture'] as String?;
    weight = data['weight'] as String?;
    userName = data['userName'] as String?;
    allergies = data['allergies'] as String?;
    return this;
  }

  getAllRelatives(var data) {
    relatives = <Relative>[];
    for (var relative in data) {
      Relative relative = Relative();
      relative.getData(relative);
      relatives.add(relative);
    }
  }

  deleteRelative(String documentID) {
    Relative? relative;
    for (var r in relatives) {
      if (r.documentID == documentID) relative = r;
    }
    if (relative != null) {
      relatives.remove(relative);
    }
  }
}
