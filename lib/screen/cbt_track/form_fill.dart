import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/screen/cbt_track/slider.dart';
import 'package:mood_tracker/utils/form_database/database_helper.dart';
import 'package:mood_tracker/models/note/note.dart';

class Formz extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  const Formz(this.appBarTitle, this.note, {super.key});

  @override
  State<Formz> createState() {
    return _FormzState(this.appBarTitle, note);
  }
}

class _FormzState extends State<Formz> {
  TextEditingController thoughtController = TextEditingController();
  TextEditingController bodyController = TextEditingController();
  TextEditingController scaleController = TextEditingController();
  TextEditingController emotionController = TextEditingController();
  final String appBarTitle;
  final Note note;
  final DatabaseHelper helper = DatabaseHelper();
  _FormzState(this.appBarTitle, this.note);
  @override
  void initState() {
    super.initState();
    thoughtController.text = note.title ?? '';
    bodyController.text = note.description ?? '';
    scaleController.text = note.scale ?? '';
    emotionController.text = note.emotion ?? '';
  }

  void updateTitle() {
    note.title = thoughtController.text;
  }

  updateEmotion() {
    note.emotion = emotionController.text;
  }

  void updateDesc() {
    note.description = bodyController.text;
  }

 updateScale() {
    note.scale = scaleController.text;
  }
  String? validateScale(String input) {
    final scale = int.tryParse(input);
    if (scale == null) {
      return 'Please enter a valid number';
    } else if (scale < 1 || scale > 10) {
      return 'Scale must be between 1 and 10';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var newvalue;
    sliders slide;
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Textfields(thoughtController, updateTitle, 'Enter your thought'),
            Textfields(bodyController, updateDesc, "Body Sensations"),
            Textfields(emotionController, updateEmotion, "Enter Emotion "),
            TextField(
              onChanged: (value) {
                debugPrint('Something changed in  field');

               updateScale();

              },
              decoration: InputDecoration(labelText: 'Scale (1-10)'),
              keyboardType: TextInputType.number,









            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 15),
            //   child: TextField(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => const sliders(),
            //         ),
            //       );
            //     },
            //     decoration: InputDecoration(
            //       labelText: 'Emotions',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(5),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FloatingActionButton(
                    child: Text('Save'),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    onPressed: _save,
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding Textfields(var Controller, var update, var labeltext) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: TextField(
        controller: Controller,
        onChanged: (value) {
          debugPrint('Something changed in  field');
          update();
        },
        decoration: InputDecoration(
          labelText: labeltext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  void _save() async {
    int result;
    DateTime now = DateTime.now();

// Format the date as a string (e.g., 'yyyy-MM-dd' format)
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    note.date = formattedDate;

    if (note.id == null) {
      result = await helper.insertForm(note);
    } else {
      result = await helper.updateForm(note);
    }
    if (result != 0) {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'Problem Saving Note');
    }
    // try {
    //   // Perform the async operation
    //   result = await helper.insertForm(note);

    //   // Check if the widget is still mounted
    //   if (!mounted) return;

    //   // Navigate back with a result and show alert dialog based on result
    //   Navigator.pop(context, true);
    //   if (result != 0) {
    //     _showAlertDialog('Status', 'Note Saved Successfully');
    //   } else {
    //     _showAlertDialog('Status', 'Problem Saving Note');
    //   }
    // } catch (e) {
    //   // Handle any exceptions that might occur
    //   if (mounted) {
    //     _showAlertDialog('Status', 'An error occurred: $e');
    //   }
    // }
  }

  Future<void> _delete() async {
    int result;
    if (note.id == null) {
      result = 0;
      _showAlertDialog('Status', 'No Note was deleted');
    } else {
      result = await helper.deleteForm(note.id);
    }

    if (result != 0) {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }
}
