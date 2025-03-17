import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:meta/meta.dart';
import 'package:mood_tracker/screen/Doctor_Side/condition.dart';
import 'package:mood_tracker/screen/Doctor_Side/patientlist.dart';
import 'package:mood_tracker/screen/Patient_Side/doclist.dart';
import 'package:path/path.dart';
import 'package:mood_tracker/screen/Doctor_Side/healthcontroller.dart';

class Sendpatient extends StatefulWidget {
  final int selectedpatindex;

  final reportId;

  final List<Map<String, dynamic>> patients;

  Sendpatient({
    super.key,
    required this.selectedpatindex,
    required this.patients,
    required this.reportId,
  });

  @override
  State<Sendpatient> createState() => _SendpatientState(reportId);
}

class _SendpatientState extends State<Sendpatient> {
  final healthcontroller = Get.put(HealthReportController());
  String _patientCondition = "";

  _SendpatientState(String reportId);

  void initState() {
    super.initState();
    healthcontroller.fetchAllReports();
    healthcontroller.fetchUserReport(widget.reportId);
  }

  void fetchconditions() {
    final ref = FirebaseDatabase.instance.ref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(" Report"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textbox(widget.selectedpatindex, widget.patients, widget.reportId,
                context),
          ],
        ));
  }
}

Widget _textbox(selectedpatindex, patients, reportId, BuildContext context) {
  print("textbox method");
  return (Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        const Text('Describe your Feedback to ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            )),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: patientcontroller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Feedback';
            }
            return null;
          },
          inputFormatters: [LengthLimitingTextInputFormatter(70)],
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: "describe your Feedback",
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          minLines: 6,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 45,
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              _save(selectedpatindex, patients, reportId,
                  context); // Save the selected mood
              // }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
            ),
            child: const Text(
              'Send ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ),
      ])));
}

// Future<void> fetchconditiontodoc(selectedpatindex, patients) async {
//   String PatientId = patients[selectedpatindex]['id'];
//   List<Map<String, dynamic>> fetchedPatientcondition =
//       await PatientCondition.fetchConditions(PatientId);
// }
Future<String?> getUserName() async {
  try {
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) return null;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserUid)
        .get();

    if (userDoc.exists) {
      return userDoc[
          'name']; // Assuming 'name' is the field for storing usernames
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching user name: $e");
    return null;
  }
}

void _save(int? selectedpatindex, patients, String reportId,
    BuildContext context) async {
  String? name = await getUserName();
  try {
    if (selectedpatindex == null) {
      print('No Patient selected');
      return;
    }
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid == null) {
      print('User not authenticated');
      return;
    } else
      print(" id of user is $currentUserUid");

    String Feedbackdesc = patientcontroller.text.trim();
    print(" Feedback is $Feedbackdesc");
    if (Feedbackdesc.isEmpty) {
      print("please enter your Feedback ");
      return;
    }
    Map<String, dynamic> selectedPatient = patients[selectedpatindex];

    String PatientId = selectedPatient['id'];
    print("id of Patient is $PatientId");

    var saved = await FirebaseFirestore.instance.collection('Feedback').add({
      'doctor name': name,
      'userId': currentUserUid,
      'reportId': reportId,
      'PatientId': PatientId,
      'Feedback': Feedbackdesc,
      'timestamp': DateTime.now()
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback submitted to Patient.')),
    );
    print("Success");
    // Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Feedback failed to submit')),
    );
  }

  patientcontroller.clear();

  selectedpatindex = null;

  // print(currentUserUid);
}
