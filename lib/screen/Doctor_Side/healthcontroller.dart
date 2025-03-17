import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

// Fetch all health reports
class HealthReportController extends GetxController {
  var allReports = <Map<String, dynamic>>[].obs; // Reactive list of all reports
  var selectedReport =
      <String, dynamic>{}.obs; // Reactive map for selected report

  // Fetch all reports from Firebase
  Future<void> fetchAllReports() async {
    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref('Condition');
      final DatabaseEvent event = await ref.once();

      if (event.snapshot.value == null) {
        allReports.value = [];
        return;
      }

      final data = event.snapshot.value as Map?;
      if (data == null || data.isEmpty) {
        allReports.value = [];
        return;
      }

      allReports.value = data.entries.map((entry) {
        final reportData = entry.value as Map?;
        if (reportData == null)
          return {"userId": entry.key}; // Handle missing data
        return {"userId": entry.key, ...Map<String, dynamic>.from(reportData)};
      }).toList();
    } catch (e) {
      print("Error fetching all reports: $e");
      allReports.value = []; // Ensure it's reset to an empty list on error
    }
  }

  // Fetch a specific user's report
  void fetchUserReport(String userId) {
    try {
      // Check if `allReports` is not empty
      if (allReports.isEmpty) {
        selectedReport.value = {}; // Default to an empty map
        return;
      }

      final report = allReports.firstWhere(
        (report) => report['userId'] == userId,
        orElse: () => {}, // Provide an empty map if no user is found
      );

      // Ensure report is a valid map
      selectedReport.value = Map<String, dynamic>.from(report);
    } catch (e) {
      print("Error fetching user report: $e");
      selectedReport.value = {}; // Reset on error
    }
  }
}
