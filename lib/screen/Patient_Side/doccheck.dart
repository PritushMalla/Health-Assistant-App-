import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';

class Diagnosis extends StatefulWidget {
  const Diagnosis({super.key});

  @override
  State<Diagnosis> createState() => _DiagnosisState();
}

class _DiagnosisState extends State<Diagnosis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawers(),
        appBar: AppBar(
          title: Text("Patient Data"),
        ),
        body: Column(
          children: [],
        ));
  }
}
