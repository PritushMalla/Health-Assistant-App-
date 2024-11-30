import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mood_tracker/models/professional/profs.dart';
import 'package:mood_tracker/utils/Professional_database/database_helper_pro.dart';

final Databasehelper_prof helper = Databasehelper_prof();

class Admin extends StatefulWidget {
  final String appBarTitle;
  final Prof prof;

  Admin(this.appBarTitle, this.prof, {super.key});

  @override
  State<Admin> createState() {
    return _AdminState(this.appBarTitle, this.prof);
  }
}

class _AdminState extends State<Admin> {
  File? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController availController = TextEditingController();
  TextEditingController specialityController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  final String appBarTitle;
  final Prof prof;

  _AdminState(this.appBarTitle, this.prof);
  @override
  void initState() {
    super.initState();
    nameController.text = prof.name ?? '';
    availController.text = prof.availability ?? '';
    specialityController.text = prof.specialisation ?? '';
    contactController.text = prof.contact_info ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: nameController,
                onChanged: (value) {
                  debugPrint('Something changed in name field');
                  prof.name = nameController.text;
                },
                decoration: InputDecoration(
                  labelText: 'Enter Name of Doctor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: availController,
                onChanged: (value) {
                  debugPrint('Something changed in Availability field');
                  prof.availability = availController.text;
                },
                decoration: InputDecoration(
                  labelText: 'Enter the availability of doctor',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: specialityController,
                onChanged: (value) {
                  debugPrint('Something changed in Speciality field');
                  prof.specialisation = specialityController.text;
                },
                decoration: InputDecoration(
                  labelText: 'Enter the speciality',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                controller: contactController,
                onChanged: (value) {
                  debugPrint('Something changed in contact field');
                  prof.contact_info = contactController.text;
                },
                decoration: InputDecoration(
                  labelText: 'Enter Doctor\'s Contact',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Pick a Profile Picture'),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                  ],
                )),
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
              ],
            )
          ],
        ),
      ),
    );
  }

  void _save() async {
    int result;
    DateTime now = DateTime.now();

    if (prof.id == null) {
      result = await helper.insertProf(prof);
    } else {
      result = await helper.updatePro(prof);
    }
    if (result != 0) {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'prof Saved Successfully');
    } else {
      Navigator.pop(context, true);
      _showAlertDialog('Status', 'Problem Saving prof');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  //request permission function
  Future<void> _requestPermissions() async {
    var statusCamera = await Permission.camera.status;
    var statusStorage = await Permission.storage.status;

    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
  }
// pick image function

  Future<void> _pickImage() async {
    await _requestPermissions(); // Request permissions first

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery); // Or ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _uploadImageToDatabase(_image); // Set the picked image
      });
    }
  }

  Future<void> _uploadImageToDatabase(var img) async {
    if (img == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select an image first!')));
      return;
    }

    // Store the image locally (or upload it to a cloud service)
    String imagePath = img!.path;
    print("$imagePath");

    prof.pic = imagePath;
  }
}
