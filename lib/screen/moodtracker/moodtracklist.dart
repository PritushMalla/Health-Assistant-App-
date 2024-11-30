import 'package:flutter/material.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/mood_tracker/mooddata.dart';
import 'package:mood_tracker/screen/moodtracker/mood.dart';
import 'package:mood_tracker/utils/mood_tracking_database/database_helper_sec.dart';
import 'package:sqflite/sqflite.dart';

class Moodlist extends StatefulWidget {
  const Moodlist({super.key});

  @override
  State<Moodlist> createState() => _MoodlistState();
}

class _MoodlistState extends State<Moodlist> {
  List<MoodData>? moodlist = [];
  int count = 0;
  final DatabaseHelper_Mood databaseHelper = DatabaseHelper_Mood();

  @override
  void initState() {
    super.initState();
    updatemoodListView(); // Update the mood list view on initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(title: Text('Entries')),
      body: moodlist == null || moodlist!.isEmpty
          ? Center(child: Text('No entries found.'))
          : listViewer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToForm('Entry', MoodData(' ', ' ', ' '));
        },
        tooltip: 'Fill new form',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView listViewer() {
    return ListView.builder(
      itemCount: count, // Pass the count to the ListView
      itemBuilder: (context, position) {
        return Container(
          color: Colors.white,
          child: ListTile(
            title: Text(moodlist![position].moodtitle),
            subtitle: Text(moodlist![position].date),
          ),
        );
      },
    );
  }

  void navToForm(String title, MoodData mooddata) async {
    bool result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return moody(mooddata, title);
      },
    ));

    // Optionally, you can refresh the list when coming back from the form
    if (result == true) {
      updatemoodListView();
    }
  }

  updatemoodListView() async {
    try {
      final Database db = await databaseHelper.database;

      List<MoodData> moodList1 = await databaseHelper.getmoodList();

      setState(() {
        
        moodlist = moodList1;
        count = moodList1.length;
      });
    } catch (e) {
      print('Error: $e');
      // Optionally show an error message to the user
    }
  }
}
