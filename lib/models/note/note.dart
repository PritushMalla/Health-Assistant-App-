import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/utils/form_database/database_helper.dart';

/*     

Steps:
1) Note ko class banaera tesko variables initlialise garne 
2)make constructor of the class with those variables as parameters to be taken 
optional bhae [] bracket halne 
3)Setters initialise garne 
4) Getters garne 
5) // Convert Note object to Map object
6)Extract Note object from Map object

scale
emotion

 */
String loggedInEmail = FirebaseAuth.instance.currentUser?.email ?? '';

class Note {
  int? _id;
  String _title = '';
  String _description = '';
  String _scale = '';
  String _emotion = '';

  String _date = ' ';

  bool isNew = false;

  // Constructor with optional parameter for description
  Note(this._title, this._date, this._emotion, this._scale,
      [this._description = '']);

  // Named constructor with ID
  Note.withId(this._id, this._title, this._date, this._emotion, this._scale,
      [this._description = '']);

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set emotion(String newEmotion) {
    _emotion = newEmotion;
  }

  set scale(String newScale) {
    // Ensure newScale is not null and within the range 1 to 10

    _scale = newScale;
  }

  // Getters
  int? get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  String get emotion => _emotion;
  String get scale => _scale;

  // Setters

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert Note object to Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': _id,
      'title': _title,
      'description': _description,
      'emotion': _emotion,
      'scale': _scale,
      'date': _date,
    };
    return map;
  }

  // Extract Note object from Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this.emotion=map['emotion'];
    this._scale = map['scale'];
  }
}
