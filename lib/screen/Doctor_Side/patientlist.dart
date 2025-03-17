import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/screen/Patient_Side/senddoc.dart';
import 'package:mood_tracker/screen/Doctor_Side/patientdata.dart';
import 'package:mood_tracker/screen/Doctor_Side/sendpatient.dart';
import 'package:mood_tracker/screen/Doctor_Side/healthcontroller.dart';

class PatientListScreen extends StatefulWidget {
  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

TextEditingController patientcontroller = TextEditingController();

class _PatientListScreenState extends State<PatientListScreen> {
  List<Map<String, dynamic>> Patients = [];

  Future<void> fetchPatients() async {
    Patientdata Patientdatas = Patientdata();
    List<Map<String, dynamic>> fetchedPatients =
        await Patientdatas.fetchPatients();
    setState(() {
      Patients = fetchedPatients;
    });
  }

  final healthcontroller = Get.put(HealthReportController());
  void initState() {
    healthcontroller.fetchAllReports();
    fetchPatients();
  }

  @override
  Widget build(BuildContext context) {
    print("patientdata is $Patients");
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: Column(
        children: [
          // Text(Patients as String),

          Patients.isEmpty
              ? Text('No Patients found.')
              : Expanded(
                  child: ListView.builder(
                    itemCount: Patients.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(
                        children: [
                          ListTile(
                              title: Text(Patients[index]['name']),
                              subtitle: Text(Patients[index]['email']),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Sendpatient(
                                      // Pass the selected index
                                      selectedpatindex: index,
                                      patients:
                                          Patients, // Pass the list of patients
                                      reportId: Patients[index]
                                          ['id'], // Pass the reportId as userId
                                    ),
                                  ),
                                );
                              })
                        ],
                      ));
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
