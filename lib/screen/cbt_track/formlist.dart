import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/models/note/note.dart';
import 'package:mood_tracker/screen/cbt_track/form_fill.dart';
import 'package:mood_tracker/utils/form_database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

String getCurrentUserEmail() {
  final User? user = FirebaseAuth.instance.currentUser;
  return user?.email ?? '';
}

class Formlist extends StatefulWidget {
  const Formlist({super.key});

  @override
  State<Formlist> createState() => _FormlistState();
}

class _FormlistState extends State<Formlist> {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? formlist;
  int? count;

  @override
  Widget build(BuildContext context) {
    updateListView();

    if (formlist == null) {
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Entries')),
      body: listViewer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToForm('Add note', Note(' ', ' ', ' ', ' ', ''));
        },
        tooltip: 'Fill new form',
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
              title: Text(formlist![position].title),
              subtitle: Text(formlist![position].date),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 201, 47, 47),
                ),
                onPressed: () {
                  _delete(context, formlist![position]);
                },
              ),
              onTap: () {
                navToForm("Edit note", formlist![position]);
              },
            ),
          );
        }
      },
    );
  }

  Future<void> _delete(BuildContext context, Note note) async {
    print(note.id);
    int result = await databaseHelper.deleteForm(note.id);

    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
    } else {
      _showSnackBar(context, 'couldnt delete note ');
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navToForm(String title, Note note) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Formz(title, note);
        },
      ),
    );

    if (result == true) {}
  }

  Future<void> updateListView() async {
    try {
      final Database db = await databaseHelper
          .database; // Correct way to get the database instance

      List<Note> formList1 = await databaseHelper.getFormList();

      setState(() {
        formlist = formList1;
        count = formlist!.length;
      });
    } catch (e) {
      print('Error: $e');
      // Optionally show an error message to the user
    }
  }
}
