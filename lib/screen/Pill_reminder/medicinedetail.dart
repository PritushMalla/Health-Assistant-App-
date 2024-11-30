import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:mood_tracker/utils/pill_database/databasehelperp.dart';
import 'package:sizer/sizer.dart';

import '../../models/Pill_reminder/pill.dart';

DatabaseHelper_pill dbpill = DatabaseHelper_pill();

class MedicineDetail extends StatefulWidget {
  final Pill pill;

  MedicineDetail(this.pill, {super.key});

  @override
  State<MedicineDetail> createState() {
    return _MedicineDetailState(pill);
  }
}

class _MedicineDetailState extends State<MedicineDetail> {
  final Pill pill;

  _MedicineDetailState(this.pill);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details'),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Mainsection(pill: pill),
            SizedBox(height: 30),
            Padding(
                padding: EdgeInsets.only(left: 20),
                child: innermeddetail(pill)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                      onPressed: () async {
                        int result;
                        result = await dbpill.deletepill(pill.id);

                        if (result != 0) {
                          Navigator.pop(context, true);
                          _showAlertDialog('Status',
                              'Medicine Deleted Successfully', context);
                        } else {
                          Navigator.pop(context, true);
                          _showAlertDialog(
                              'Status', 'Problem Deleting Medicine', context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('Delete'),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 244, 123, 114))),
                ],
              ),
            )
          ],
        ));
  }
}

void _showAlertDialog(String title, String message, var context) {
  AlertDialog alertDialog = AlertDialog(
    title: Text(title),
    content: Text(message),
  );
  showDialog(context: context, builder: (context) => alertDialog);
}

class innermeddetail extends StatelessWidget {
  final Pill pill;
  const innermeddetail(
    this.pill, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String Pilltime = pill.time;
    DateTime pillTime = DateTime.parse(Pilltime);
    String formattedTime =
        "${pillTime.hour.toString().padLeft(2, '0')}:${pillTime.minute.toString().padLeft(2, '0')}";

    return ListView(shrinkWrap: true, children: [
      meddetail(fieldtitle: 'Medicine Type', fieldinfo: pill.Mtype),
      meddetail(fieldtitle: 'Dose Interval ', fieldinfo: pill.Minterval),
      meddetail(fieldtitle: "Start Time ", fieldinfo: formattedTime),
    ]);
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
      padding: EdgeInsets.symmetric(vertical: 0.2.inches),
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

class Mainsection extends StatelessWidget {
  final Pill pill;

  Mainsection({
    super.key,
    required this.pill,
  });

  @override
  Widget build(BuildContext context) {
    final img = pill.Mtype;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset("assets/images/$img.png", height: 0.7.inches),
        Padding(
          padding: const EdgeInsets.only(right: 25.0),
          child: Column(
            children: [
              medicineinfo(
                fieldtitle: " Medicine Name",
                fieldinfo: pill.Mname,
              ),
              SizedBox(height: 40),
              medicineinfo(fieldtitle: 'Dosage', fieldinfo: pill.dose),
            ],
          ),
        ),
      ],
    );
  }
}

class medicineinfo extends StatelessWidget {
  final String fieldtitle;
  final String fieldinfo;
  medicineinfo({
    super.key,
    required this.fieldtitle,
    required this.fieldinfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fieldtitle,
          style: TextStyle(color: Colors.grey),
        ),
        Text(fieldinfo,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
      ],
    );
  }
}
