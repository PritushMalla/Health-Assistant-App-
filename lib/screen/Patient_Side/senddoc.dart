import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mood_tracker/screen/Patient_Side/doclist.dart';

TextEditingController namecontroller = TextEditingController();

class Senddoc extends StatelessWidget {
  final Selecteddocindex;
  final List<Map<String, dynamic>> doctors;

  Senddoc({super.key, required this.Selecteddocindex, required this.doctors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor Report "),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textbox(Selecteddocindex, doctors, context),
          ],
        ));
  }
}

Widget _textbox(Selecteddocindex, doctors, BuildContext context) {
  print("textbox method");
  return (Padding(
      padding: EdgeInsets.all(16),
      child: Column(children: [
        // const Text('Name ',
        //     style: TextStyle(
        //       color: Colors.grey,
        //       fontSize: 14.0,
        //     )),
        // TextFormField(
        //     controller: namecontroller,
        //     validator: (value) {
        //       if (value == null || value.isEmpty) {
        //         return 'Please enter your condition';
        //       }
        //       return null;
        //     }),
        const Text('Describe your condition to ',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            )),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: descController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your condition';
            }
            return null;
          },
          inputFormatters: [LengthLimitingTextInputFormatter(70)],
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: "describe your condition",
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
              _save(
                  Selecteddocindex, doctors, context); // Save the selected mood
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

void _save(int? Selecteddocindex, doctors, BuildContext context) async {
  String? name = await getUserName();
  try {
    if (Selecteddocindex == null) {
      print('No doctor selected');
      return;
    }
    String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      print('User not authenticated');
      return;
    } else
      print(" id of user is $currentUserUid");

    String conditiondesc = descController.text.trim();
    print(" condition is $conditiondesc");
    if (conditiondesc.isEmpty) {
      print("please enter your condition ");
      return;
    }

    Map<String, dynamic> selectedDoctor = doctors[Selecteddocindex!];

    String doctorId = selectedDoctor['id'];
    String reportId =
        FirebaseFirestore.instance.collection('Condition').doc().id;

    try {
      var saved = await FirebaseFirestore.instance.collection('Condition').add({
        'reportId': reportId,
        'userId': currentUserUid,
        'Name': name,
        'doctorId': doctorId,
        'Condition': conditiondesc,
        'timestamp': DateTime.now().toString()
      });
    } catch (e) {
      print("Error $e");
    }
    print(namecontroller);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Condition submitted to doctor.')),
    );
    // Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Condition failed to submit')),
    );
  }

  descController.clear();

  Selecteddocindex = null;

  // print(currentUserUid);
}
