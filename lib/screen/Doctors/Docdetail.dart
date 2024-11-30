import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/screen/Doctors/Docdetail.dart';
import 'package:mood_tracker/models/professional/profs.dart';
import 'package:mood_tracker/screen/Admin/Admin_prof_list.dart';
import 'package:mood_tracker/utils/Professional_database/database_helper_pro.dart';
import 'package:sqflite/sqflite.dart';

class Docdetail extends StatefulWidget {
  final Prof prof;
  Databasehelper_prof helper = Databasehelper_prof();
  Docdetail(this.prof, {super.key});

  @override
  State<Docdetail> createState() {
    return _DocdetailState(prof);
  }
}

class _DocdetailState extends State<Docdetail> {
  final Prof prof;
  _DocdetailState(this.prof);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Column(
        children: [Mainsection(prof: prof), Bottomsection(prof: prof)],
      ),
    );
  }
}

class Mainsection extends StatelessWidget {
  final Prof prof;
  const Mainsection({super.key, required this.prof});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(18),
          child: Image.file(
            File(prof.pic),
            fit: BoxFit.contain,
            height: 100,
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Column(
            children: [
              Text(
                "Doctor\s name:",
                style: TextStyle(color: Colors.grey),
              ),
              Text(prof.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(
                "Specialty:",
                style: TextStyle(color: Colors.grey),
              ),
              Text(prof.specialisation,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        )
      ],
    );
  }
}

class Bottomsection extends StatelessWidget {
  final Prof prof;
  const Bottomsection({super.key, required this.prof});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 40),
      shrinkWrap: true,
      children: [
        meddetail(fieldtitle: "Availability", fieldinfo: prof.availability),
        meddetail(fieldtitle: "Contact No.", fieldinfo: prof.contact_info),
      ],
    );
  }
}

class meddetail extends StatelessWidget {
  final fieldtitle;
  final fieldinfo;

  const meddetail(
      {super.key, required this.fieldtitle, required this.fieldinfo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(fieldtitle),
          Text(fieldinfo, style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
