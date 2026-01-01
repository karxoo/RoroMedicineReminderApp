class Relative {
  String? name, email, phoneNumber, uid, documentID;
  Relative();
  Relative getData(var data) {
    phoneNumber = data['phoneNumber'] as String?;
    email = data['email'] as String?;
    uid = data['uid'] as String?;
    name = data['name'] as String?;
    documentID = data['documentID'] as String?;
    return this;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['uid'] = uid;
    data['name'] = name;
    return data;
  }
}
