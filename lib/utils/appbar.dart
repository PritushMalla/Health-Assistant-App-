// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:health_assistant/appointment/appointmenthome.dart';
// // import 'package:health_assistant/appointment/category.dart';
// // import 'package:health_assistant/appointment/docprofile.dart';
// // import 'package:health_assistant/appointment/settings.dart';

// class BottomNav extends StatelessWidget {
//   const BottomNav({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     IconButton appbarbutton(BuildContext context, destination, icon) {
//       return IconButton(
//         icon: Icon(icon),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => destination),
//           );
//         },
//       );
//     }

//     return BottomAppBar(
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//         appbarbutton(context, Appointment(), Icons.home),
//         appbarbutton(context, CategoryScreen(), Icons.message),
//         appbarbutton(context, Settingspage(), Icons.man),
//         appbarbutton(context, DoctorProfile(), Icons.settings)
//       ]),
//     );
//   }
// }
