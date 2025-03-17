// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:mood_tracker/main.dart';

// class Emergency extends StatelessWidget {
//   const Emergency({super.key});

//   void _callNumber(String number) async {
//     bool? res = await FlutterPhoneDirectCaller.callNumber(number);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawers(),
//       body: Padding(
//           padding: const EdgeInsets.only(left: 10.0, bottom: 5),
//           child: Card(
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                       child: Text(
//                     "'Every year more than 700 000 people die due to suicide globally. For every suicide, there are many more people who attempt to take their lives. Almost 77 percent of suicides occur in low and middle-income countries.While suicide is a serious public health problem, it can be prevented with timely evidence-based, and often low-cost interventions including early identification of risk, assessing, managing, and follow-up of people exhibiting suicidal behavior.'",
//                     style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
//                   )),
//                   Text("Suicide Hotline"),
//                   Center(
//                     child: ElevatedButton(
//                         onPressed: () {
//                           _callNumber('9841-XXXXX');
//                         },
//                         child: Text("Call Emergency Hotline ")),
//                   )
//                 ],
//               ))),
//     );
//   }
// }
