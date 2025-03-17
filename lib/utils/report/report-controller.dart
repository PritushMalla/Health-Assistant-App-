import 'package:get/get.dart';
import 'package:mood_tracker/models/reports/condition.dart';
import 'package:mood_tracker/screen/report/report_controller.dart';

class Reportbinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ReportController>(ReportController());
  }
}
