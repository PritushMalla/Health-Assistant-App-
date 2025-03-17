import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mood_tracker/models/reports/condition.dart';
import 'package:mood_tracker/screen/report/report_controller.dart';

class Reportpage extends StatelessWidget {
  Reportpage({super.key});
  ReportController reportController = Get.put(ReportController());

  void initState() {
    reportController.getData();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _responseController = TextEditingController();
    List<Map<String, dynamic>> responses = [];

    reportController.getData();
    return GetBuilder<ReportController>(
        init: ReportController(),
        initState: (_) {
          reportController.getData();
        },
        builder: (reportController) {
          reportController.getData();
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text('Patient Report'),
              ),
              body: Center(child: Obx(() {
                return ListView.builder(
                    itemCount: reportController.conditionlist.length,
                    itemBuilder: (BuildContext context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Name: ${reportController.conditionlist[index].name}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.normal),
                                ),
                                Text(
                                    " Condition : ${reportController.conditionlist[index].condition}",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    " Time: ${reportController.conditionlist[index].timestamps as String}",
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.normal)),
                                // TextField(
                                //   controller: _responseController,
                                //   maxLines: 5,
                                //   decoration: InputDecoration(
                                //     border: OutlineInputBorder(),
                                //     hintText: "Write your response...",
                                //   ),
                                // ),
                              ],
                            )

                            //  IconButton(onPressed: , icon: icon)
                          ],
                        ),
                      );
                    });
              })));
        });
  }
}
