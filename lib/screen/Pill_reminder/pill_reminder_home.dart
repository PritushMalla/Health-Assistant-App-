import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/screen/Pill_reminder/medicinedetail.dart';
import 'package:mood_tracker/screen/Pill_reminder/pill_reminder.dart';
import 'package:mood_tracker/utils/pill_database/databasehelperp.dart';
import 'package:sizer/sizer.dart';
import 'package:mood_tracker/models/Pill_reminder/pill.dart';
import 'package:sqflite/sqflite.dart';

import '../../main.dart';

final DatabaseHelper_pill databaseHelper = DatabaseHelper_pill();

class Pillremind extends StatefulWidget {
  const Pillremind({super.key});

  @override
  State<Pillremind> createState() => _PillremindState();
}

class _PillremindState extends State<Pillremind> {
  List<Pill> pilllist = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    updatePillListView();
    // Update the pill list view on initialization
  }

  @override
  Widget build(BuildContext context) {
    updatePillListView();
    if (pilllist == null) {
      updatePillListView();
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Pill Reminder')),
      drawer: Drawers(),
      body: Column(
        children: [
          // Top container
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "A Pill a day keeps the trauma away",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: "OleoScript-Regular",
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Text("Daily Dose Reminder",
                    style: Theme.of(context).textTheme.headlineSmall),
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),

          // Bottom container (GridView)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(top: 1.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.5,
              ),
              itemCount: pilllist.length,
              itemBuilder: (context, index) {
                final pillinterval = pilllist[index].Minterval;
                final pill_img = pilllist[index].Mtype;
                return InkWell(
                  highlightColor: Colors.white,
                  splashColor: Colors.black,
                  onTap: () {
                    med_detail(context, pilllist[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(236, 226, 226, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/$pill_img.png",
                          height: 0.7.inches,
                        ),
                        Text(
                          pilllist[index].Mname,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 129, 104, 198),
                          ),
                        ),
                        if (pillinterval != "null")
                          Text(
                            "Every $pillinterval hours",
                            style: const TextStyle(fontSize: 10),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result2 = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Reminder(Pill(
                ' ',
                '',
                '',
                '',
                ' ',
              )),
            ),
          );

          // If a pill was added, update the pill list
          if (result2 == true) {
            updatePillListView();
            print(pilllist);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Method to fetch and update the pill list view
  void updatePillListView() async {
    try {
      final Database db = await databaseHelper.database;
      List<Pill> pillList = await databaseHelper.getPillList();

      setState(() {
        pilllist = pillList;
        count = pilllist.length;
      });
    } catch (e) {
      print('Error: $e');

      // Optionally show an error message to the user
    }
  }

  // Method to navigate to medicine details and refresh on return
  med_detail(context, Pill pilllist) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MedicineDetail(pilllist)),
    );

    // Update the pill list after returning from the detail page
    if (result == true) {
      updatePillListView();
    }
  }
}
