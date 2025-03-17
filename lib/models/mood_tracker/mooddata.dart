class MoodData {
  int? _id;
  String _Healthtitle = '';
  String? _description = ' ';
  String _date = ' ';

  MoodData(this._Healthtitle, this._date, [this._description]);
  MoodData.withId(this._id, this._Healthtitle, this._date, [this._description]);

  // Setters with conditions
  set moodtitle(String newmoodTitle) {
    if (newmoodTitle.length <= 255) {
      _Healthtitle = newmoodTitle;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  set description(String? newDescription) {
    if (newDescription != null && newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  // Getters
  int? get id => _id;
  String get moodtitle => _Healthtitle;
  String? get description => _description;
  String get date => _date;

  // Convert MoodData object to map
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'moodtitle': moodtitle,
      'description': description,
      'date': date
    };
    return map;
  }

  // Convert map to MoodData object
  MoodData.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _Healthtitle = map['moodtitle'];
    _description = map['description'] as String? ?? '';
    _date = map['date']; // Fixing date assignment
  }

  MoodData.fromtitleMapObject(Map<String, dynamic> map) {
    _Healthtitle = map['moodtitle'] as String;
    _date = map['date'] as String;
  }
}
