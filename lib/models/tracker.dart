import 'package:cloud_firestore/cloud_firestore.dart';

class TrackerModel {
  Sleep? sleepTracker;
  WeightTracker? weightTracker;
  BloodPressureTracker? bloodPressureTracker;
  BloodSugarTracker? bloodSugarTracker;
  TrackerModel();
}

class Sleep {
  int? hours, minutes;
  String? notes;
  DateTime? dateTime;

  Sleep({this.hours, this.minutes, this.notes, this.dateTime});
}

class SleepTracker {
  bool? isTracking;
  Sleep? sleepData;
  SleepTracker();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['dateAndTime'] = sleepData?.dateTime.toString();
    map['hours'] = sleepData?.hours.toString();
    map['minutes'] = sleepData?.minutes.toString();
    map['notes'] = sleepData?.notes;

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    Sleep sleepTracker = Sleep();
    sleepTracker.dateTime = DateTime.tryParse(map['dateAndTime'] ?? '') ?? DateTime.now();
    sleepTracker.hours = int.tryParse(map['hours']?.toString() ?? '') ?? 0;
    sleepTracker.minutes = int.tryParse(map['minutes']?.toString() ?? '') ?? 0;
    sleepTracker.notes = map['notes']?.toString() ?? '';
    return sleepTracker;
  }

  List<Sleep> loadData(QuerySnapshot snapshot) {
    final List<DocumentSnapshot> documents = snapshot.docs;
    List<Sleep> sleepList = [];
    for (var data in documents) {
      Map<String, dynamic> map = data.data() as Map<String, dynamic>;

      sleepList.add(fromMap(map));
    }
    return sleepList;
  }
}

class Weight {
  int? weight;
  String? notes;
  DateTime? dateTime;

  Weight({this.weight, this.notes, this.dateTime});
}

class WeightTracker {
  bool? isTracking;
  Weight? weightData;
  WeightTracker();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['dateAndTime'] = weightData?.dateTime.toString();
    map['weight'] = weightData?.weight.toString();
    map['notes'] = weightData?.notes;

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    Weight weightTracker = Weight();
    weightTracker.dateTime = DateTime.tryParse(map['dateAndTime'] ?? '') ?? DateTime.now();
    weightTracker.weight = int.tryParse(map['weight']?.toString() ?? '') ?? 0;
    weightTracker.notes = map['notes']?.toString() ?? '';
    return weightTracker;
  }

  List<Weight> loadData(QuerySnapshot snapshot) {
    List<DocumentSnapshot> documents = snapshot.docs;
    List<Weight> weightList = [];
    for (var data in documents) {
      Map<String, dynamic> map = data.data() as Map<String, dynamic>;
      weightList.add(fromMap(map));
    }
    return weightList;
  }
}

class BloodSugar {
  int? bloodSugar;
  String? notes;
  DateTime? dateTime;
  BloodSugar({this.bloodSugar, this.notes, this.dateTime});
}

class BloodSugarTracker {
  bool? isTracking;
  BloodSugar? bloodSugar;
  BloodSugarTracker();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['dateAndTime'] = bloodSugar?.dateTime.toString();
    map['blood_sugar'] = bloodSugar?.bloodSugar.toString();
    map['notes'] = bloodSugar?.notes;

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    BloodSugar bloodSugar = BloodSugar();
    bloodSugar.dateTime = DateTime.tryParse(map['dateAndTime'] ?? '') ?? DateTime.now();
    bloodSugar.bloodSugar = int.tryParse(map['blood_sugar']?.toString() ?? '') ?? 0;
    bloodSugar.notes = map['notes']?.toString() ?? '';
    return bloodSugar;
  }

  List<BloodSugar> loadData(QuerySnapshot snapshot) {
    List<DocumentSnapshot> documents = snapshot.docs;
    List<BloodSugar> bloodSugarList = [];
    for (var data in documents) {
      Map<String, dynamic> map = data.data() as Map<String, dynamic>;
      bloodSugarList.add(fromMap(map));
    }
    return bloodSugarList;
  }
}

class BloodPressure {
  int? systolic, diastolic, pulse;
  String? notes;
  DateTime? dateTime;

  BloodPressure({this.systolic, this.diastolic, this.pulse, this.notes, this.dateTime});
}

class BloodPressureTracker {
  bool? isTracking;
  BloodPressure? bloodPressure;
  BloodPressureTracker();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};

    map['dateAndTime'] = bloodPressure?.dateTime.toString();
    map['diastolic'] = bloodPressure?.diastolic.toString();
    map['systolic'] = bloodPressure?.systolic.toString();
    map['pulse'] = bloodPressure?.pulse.toString();
    map['notes'] = bloodPressure?.notes;
    return map;
  }

  fromMap(Map<String, dynamic> map) {
    BloodPressure bloodPressure = BloodPressure();
    bloodPressure.dateTime = DateTime.tryParse(map['dateAndTime'] ?? '') ?? DateTime.now();
    bloodPressure.diastolic = int.tryParse(map['diastolic']?.toString() ?? '') ?? 0;
    bloodPressure.systolic = int.tryParse(map['systolic']?.toString() ?? '') ?? 0;
    bloodPressure.pulse = int.tryParse(map['pulse']?.toString() ?? '') ?? 0;
    bloodPressure.notes = map['notes']?.toString() ?? '';
    return bloodPressure;
  }

  List<BloodPressure> loadData(QuerySnapshot snapshot) {
    List<DocumentSnapshot> documents = snapshot.docs;
    List<BloodPressure> bloodPressureList = [];
    for (var data in documents) {
       Map<String, dynamic> map = data.data() as Map<String, dynamic>;
      bloodPressureList.add(fromMap(map));
    }
    return bloodPressureList;
  }
}
