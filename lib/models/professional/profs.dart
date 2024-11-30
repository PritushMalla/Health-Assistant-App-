class Prof {
  int? _id;
  String _name = '';
  String _availability = '';
  String _specialisation = ' ';
  String _contact_info = '';
  String _pic = '';

  bool isNew = false;

  // Constructor with optional parameter for availability
  Prof(this._name, this._specialisation, this._contact_info,
      [this._availability = '', this._pic = '']);

  // availabilityd constructor with ID
  Prof.withId(this._id, this._name, this._specialisation, this._contact_info,
      [this._availability = '', this._pic = '']);

  // Getters
  int? get id => _id;
  String get name => _name;
  String get availability => _availability;
  String get specialisation => _specialisation;
  String get contact_info => _contact_info;
  String get pic => _pic;

  // Setters

  set contact_info(String newcontact_info) {
    if (_contact_info.length <= 10) {
      _contact_info = newcontact_info;
    }
  }

  set pic(String newpic) {
    _pic = newpic;
  }

  set name(String newname) {
    if (newname.length <= 255) {
      _name = newname;
    }
  }

  set availability(String newavailability) {
    if (newavailability.length <= 255) {
      _availability = newavailability;
    }
  }

  set specialisation(String newspecialisation) {
    _specialisation = newspecialisation;
  }
// //  String ProTable = 'Pill_table';

  // Convert Prof object to Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': _id,
      'name': _name,
      'pic': _pic,
      'availability': _availability,
      'specialisation': _specialisation,
      'contact_info': _contact_info
    };
    return map;
  }

  // Extract Prof object from Map object
  Prof.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._pic = map['pic'];
    this._name = map['name'];
    this._availability = map['availability'];
    this._specialisation = map['specialisation'];
    this._contact_info = map['contact_info'];
  }
}
