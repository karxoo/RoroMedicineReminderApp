import 'dart:convert';

class Reminder {
  int? _id;
  String? _name;
  String? _type;
  int? _times;
  String? _time1, _time2, _time3;
  int? _notificationID;
  Map<String, dynamic>? _intakeHistory;

  Reminder(this._name, this._type, this._time1, this._time2, this._time3,
      this._times, this._notificationID, this._intakeHistory);

  Reminder.withId(this._id, this._name, this._type, this._time1, this._time2,
      this._time3, this._times, this._notificationID);

  int? get id => _id;
  int? get times => _times;

  Map<String, dynamic>? get intakeHistory => _intakeHistory;

  set intakeHistory(Map<String, dynamic>? value) {
    _intakeHistory = value;
  }

  int? get notificationID => _notificationID;

  set notificationID(int? value) {
    _notificationID = value;
  }

  String? get name => _name;

  String? get type => _type;

  String? get time3 => _time3;

  String? get time2 => _time2;

  String? get time1 => _time1;

  set name(String? newName) {
    if (newName == null) return;
    if (newName.length <= 255) {
      _name = newName;
    }
  }

  set type(String? newReminderType) {
    if (newReminderType == null) return;
    if (newReminderType.length <= 255) {
      _type = newReminderType;
    }
  }

  set time1(String? newTime1) {
    _time1 = newTime1;
  }

  set time2(String? newTime2) {
    _time2 = newTime2;
  }

  set time3(String? newTime3) {
    _time3 = newTime3;
  }

  set times(int? newTimes) {
    if (newTimes == null) return;
    if (newTimes > 0 && newTimes < 4) {
      _times = newTimes;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['type'] = _type;
    map['times'] = _times;
    map['time1'] = _time1;
    map['time2'] = _time2;
    map['time3'] = _time3;
    map['notification_id'] = _notificationID;
    String temp = jsonEncode(intakeHistory ?? {});
    map['intake_history'] = temp;
    return map;
  }

  Reminder.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'] as int?;
    _time1 = map['time1'] as String?;
    _time2 = map['time2'] as String?;
    _time3 = map['time3'] as String?;
    _times = map['times'] as int?;
    _type = map['type'] as String?;
    _name = map['name'] as String?;
    _notificationID = map['notification_id'] as int?;
    if (map['intake_history'] != null) {
      Map<String, dynamic> temp = jsonDecode(map['intake_history']);
      _intakeHistory = temp;
    } else {
      _intakeHistory = {};
    }
  }
}
