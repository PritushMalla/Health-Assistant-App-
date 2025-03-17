import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mood_tracker/models/reports/condition.dart';

class ReportController extends GetxController {
  RxList conditionlist = <ConditionModel>[].obs;

  String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;
  Future<void> getData() async {
    try {
      QuerySnapshot conditions = await FirebaseFirestore.instance
          .collection('Condition')
          .where('doctorId', isEqualTo: currentUserUid)
          .get();
      conditionlist.clear();

      for (var condition in conditions.docs) {
        conditionlist.add(ConditionModel(
          condition['reportId'],
          condition['Name'],
          condition['Condition'],
          condition['timestamp'],
        ));
      }
    } catch (e) {
      print("Error$e");
      Get.snackbar('error :', '$e');
    }
  }
}
