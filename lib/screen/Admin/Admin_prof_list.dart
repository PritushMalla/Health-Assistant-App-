import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/professional/profs.dart';
import 'package:mood_tracker/screen/Admin/Admin_fill_info.dart';
import 'package:mood_tracker/utils/Professional_database/database_helper_pro.dart';
import 'package:sqflite/sqflite.dart';

class Proflist extends StatefulWidget {
  const Proflist({super.key});

  @override
  State<Proflist> createState() => _ProflistState();
}

class _ProflistState extends State<Proflist> {
  final Databasehelper_prof helper = Databasehelper_prof();
  List<Prof>? proflist;
  int? count;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (proflist == null) {
      updateListView();
    }

    return Scaffold(
      drawer: Drawers(),
      appBar: AppBar(title: Text('List of Doctors')),
      body: listViewer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToForm('Add Doctor', Prof(' ', ' ', ' ', ' '));
        },
        tooltip: 'Add new Doctor',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView listViewer() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, int position) {
        if (count == null) {
          updateListView();
        } else {
          return Container(
            color: Colors.white,
            child: ListTile(
              title: Text(proflist![position].name),
              subtitle: Text(proflist![position].availability),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 201, 47, 47),
                ),
                onPressed: () {
                  _delete(context, proflist![position]);
                },
              ),
              onTap: () {
                navToForm("Edit prof", proflist![position]);
                // print(proflist![position]);
              },
            ),
          );
        }
      },
    );
  }

  Future<void> _delete(BuildContext context, Prof prof) async {
    print(prof.id);
    int result = await helper.deleteProf(prof.id);

    if (result != 0) {
      _showSnackBar(context, 'Prof Deleted Successfully');
    } else {
      _showSnackBar(context, 'couldnt delete prof ');
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navToForm(String title, Prof prof) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Admin(title, prof);
    }));
  }

  Future<void> updateListView() async {
    try {
      final Database db =
          await helper.database; // Correct way to get the database instance

      List<Prof> proList1 = await helper.getProList();

      setState(() {
        proflist = proList1;
        count = proflist!.length;
      });
    } catch (e) {
      print('Error: $e');
      // Optionally show an error message to the user
    }
  }
}
