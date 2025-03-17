// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class ReportController extends GetxController {
//   var conditionlist = <Condition>[].obs;

//   // This method gets the report data
//   void getData() async {
//     // Simulating data fetching from Firestore
//     final reportData = await FirebaseFirestore.instance.collection('Feedback').get();
//     conditionlist.assignAll(reportData.docs.map((doc) => Condition.fromMap(doc.data())).toList());
//   }

//   // This method sends the doctor's response to Firestore
//   Future<void> sendDoctorResponse(String reportId, String responseContent,String docid) async {
    
//     try {
//       await FirebaseFirestore.instance.collection('responses').add({
//         'reportId': reportId,
//         'responseContent': responseContent,
//         'doctorId': docid, // Replace with actual doctor ID
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       Get.snackbar('Success', 'Response sent successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send response: $e');
//     }
//   }
// }