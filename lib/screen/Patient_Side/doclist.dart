import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/screen/Patient_Side/senddoc.dart';
import 'doctorservice.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

TextEditingController descController = TextEditingController();

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Map<String, dynamic>> doctors = [];

  Future<void> fetchDoctors() async {
    DoctorService doctorService = DoctorService();
    List<Map<String, dynamic>> fetchedDoctors =
        await doctorService.fetchDoctors();
    setState(() {
      doctors = fetchedDoctors;
    });
  }

  void initState() {
    fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      body: Column(
        children: [
          // Text(doctors as String),

          doctors.isEmpty
              ? Text('No doctors found.')
              : Expanded(
                  child: ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: Column(
                        children: [
                          ListTile(
                            title: Text(doctors[index]['name']),
                            subtitle: Text(doctors[index]['email']),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Senddoc(
                                          Selecteddocindex: index,
                                          doctors: doctors)));
                              // print(
                              //     " the selected doc index is $Selecteddocindex");
                            },
                          ),
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
