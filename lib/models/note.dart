class Note {
  int? _id;
  String? _title;
  String? _description;
  String? _dateCreated;
  String? _date;
  int? _priority;

  Note(this._title, this._date, this._dateCreated, this._priority,
      [this._description]);

  Note.withId(this._id, this._title, this._dateCreated, this._priority,
      [this._description]);

  int? get id => _id;

  String? get title => _title;

  String? get description => _description;

  int? get priority => _priority;

  String? get dateCreated => _dateCreated;

  String? get date => _date;

  set title(String? newTitle) {
    if (newTitle == null) return;
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String? newDescription) {
    if (newDescription == null) return;
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set priority(int? newPriority) {
    if (newPriority == null) return;
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

  set date(String? newDate) {
    _date = newDate;
  }

  set dateCreated(String? newDateCreated) {
    _dateCreated = newDateCreated;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['dateCreated'] = _dateCreated;
    map['date'] = _date;
    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'] as int?;
    _title = map['title'] as String?;
    _description = map['description'] as String?;
    _priority = map['priority'] as int?;
    _dateCreated = map['dateCreated'] as String?;
    _date = map['date'] as String?;
  }
}
