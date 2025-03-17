import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/fetchrole.dart';
import 'package:mood_tracker/screen/report/report_controller.dart';

class SomeScreen extends StatelessWidget {
  RoleController roleController = RoleController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check User Role"),
      ),
      body: GetBuilder<RoleController>(
        init: RoleController(),
        builder: (controller) {
          return Center(
            child: ElevatedButton(
              onPressed: () async {
                // Call the getRole method to fetch and check the role
                await roleController.getRole();

                // Once roles are fetched, check if the current user is a doctor
                roleController.isDoctor();

                // Optionally, you can refresh the UI based on role check
                // Logic for UI based on currentUser's role
              },
              child: Text("Check if I'm a Doctor"),
            ),
          );
        },
      ),
    );
  }
}
