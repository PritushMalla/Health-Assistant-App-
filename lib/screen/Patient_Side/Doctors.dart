import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/main.dart';

import 'package:mood_tracker/models/professional/profs.dart';
import 'package:mood_tracker/screen/Patient_Side/Docdetail.dart';
import 'package:mood_tracker/utils/Professional_database/database_helper_pro.dart';
import 'package:sqflite/sqflite.dart';

final Databasehelper_prof helper = Databasehelper_prof();

class Doctors extends StatefulWidget {
  const Doctors({super.key});

  @override
  State<Doctors> createState() => _DoctorsState();
}

class _DoctorsState extends State<Doctors> {
  List<Prof> doclist = [];
  int count = 0;
  @override
  void initState() {
    super.initState();
    updatedocListView(); // Update the pill list view on initialization
  }

  @override
  Widget build(BuildContext context) {
    updatedocListView();
    if (doclist == null) {
      updatedocListView();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Doctors ')),
      drawer: Drawers(),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20)),
          Expanded(
              child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1,
            ),
            itemCount: doclist.length,
            itemBuilder: (context, index) {
              return InkWell(
                highlightColor: Colors.white,
                splashColor: Colors.black,
                onTap: () {
                  doc_detail(context, doclist[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 190, 199, 245),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(18),
                          child: Image.file(
                            File(doclist[index].pic),
                            fit: BoxFit.contain,
                            height: 100,
                          )),
                      Container(
                        margin: const EdgeInsets.all(0.1),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 123, 141, 229),
                            borderRadius: BorderRadius.circular(2)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(doclist[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Center(
                              child: Text(doclist[index].specialisation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  void updatedocListView() async {
    final Database db = await helper.database;
    List<Prof> docList = await helper.getProList();

    setState(() {
      doclist = docList;
      count = doclist.length;
    });
  }

  doc_detail(context, doclisting) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Docdetail(doclisting)),
    );

    // Update the doc list after returning from the detail page
    if (result == true) {
      updatedocListView();
    }
  }
}
