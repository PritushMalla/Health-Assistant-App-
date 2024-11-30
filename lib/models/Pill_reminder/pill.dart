import 'package:flutter/material.dart';

class Pill {
  int? _id;
  String _Mname = '';
  String _dose = '';
  String _time = '';
  String _Mtype = ' ';
  String _Minterval = ' ';



  // Constructor with optional parameter for Mtype
  Pill(this._Mname, this._dose, this._Minterval, this._time,
      this._Mtype);

  // Named constructor with ID
  Pill.withId(this._id, this._Mname, this._dose, this._time,
      this._Mtype);

  // Setters

  set Mname(String newMname) {
    if (newMname.length <= 255) {
      _Mname = newMname;
    }
  }

  set Mtype(String newMtype) {
    if (newMtype.length <= 255) {
      _Mtype = newMtype;
    }
  }

  set dose(String newdosage) {
    _dose = newdosage;
  }

  set Minterval(String newMinterval) {
    _Minterval = newMinterval;
  }

  set time(String newtime) {
    _time = newtime;
  }

  // Getters
  int? get id => _id;
  String get Mname => _Mname;
  String get Mtype => _Mtype;
  String get dose => _dose;
  String get Minterval => _Minterval;
  String get time => _time;

  // Convert Pill object to Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': _id,
      'Mname': _Mname,
      'Mtype': _Mtype,
      'Dose': _dose,
      'interval': _Minterval,
      'time': _time
    };
    if(_id==null){
      map['id']=_id;

    }
    return map;

  }


  // Extract Pill object from Map object
  Pill.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id']?? '';
    this._Mname = map['Mname']?? '';
    this._Mtype = map['Mtype']?? '';
    this._dose = map['Dose']?? '';
    this.Minterval = map['interval']?? '';
    this.time = map['time']?? '';
  }
}

