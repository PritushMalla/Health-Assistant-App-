import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:mood_tracker/fetchrole.dart';
import 'package:mood_tracker/screen/Doctor_Side/patientlist.dart';
import 'package:mood_tracker/screen/report/report.dart';

class RoleBasedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    RoleController roleController = Get.put(RoleController());
    roleController.isDoctor.value == false.obs;
    roleController.getRole();

    return Scaffold(
      appBar: AppBar(
        title: Text("Role-Based Access"),
      ),
      body: Center(
        child: Obx(() {
          print(roleController.isDoctor.value);
          // Show content based on the user's role
          if (roleController.isDoctor.value == true) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome, Doctor!"),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the patient list
                    Get.to(() => PatientListScreen());
                  },
                  child: Text("View Patient List"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to patient reports

                    Get.to(() => Reportpage());
                  },
                  child: Text("View Patient Reports"),
                ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Welcome, User!"),
                Text("You do not have access to this content."),
              ],
            );
          }
        }),
      ),
    );
  }
}
