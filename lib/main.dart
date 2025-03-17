import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:mood_tracker/Accounts/Signup.dart';
import 'package:mood_tracker/Accounts/login.dart';
import 'package:mood_tracker/Accounts/logout.dart';
import 'package:mood_tracker/Call.dart';
import 'package:mood_tracker/Doctorview.dart';
import 'package:mood_tracker/Emergency.dart';
import 'package:mood_tracker/Health/symptompredict.dart';
import 'package:mood_tracker/Home.dart';
import 'package:mood_tracker/fetchrole.dart';
import 'package:mood_tracker/models/Pill_reminder/pill.dart';
import 'package:mood_tracker/models/model.dart';
import 'package:mood_tracker/role.dart';
import 'package:mood_tracker/screen/Admin/Admin_prof_list.dart';
import 'package:mood_tracker/screen/Doctor_Side/patientdata.dart';
import 'package:mood_tracker/screen/Doctor_Side/patientlist.dart';
import 'package:mood_tracker/screen/Doctor_Side/sendpatient.dart';
import 'package:mood_tracker/screen/Patient_Side/Doctors.dart';
import 'package:mood_tracker/screen/Patient_Side/doclist.dart';
import 'package:mood_tracker/screen/Patient_Side/doctorfeedback.dart';
import 'package:mood_tracker/screen/Pill_reminder/confirmreminder.dart';
import 'package:mood_tracker/screen/Quiz/Depressionquiz.dart';
import 'package:mood_tracker/screen/diet_recommendation/diet_recommend.dart';
import 'package:mood_tracker/screen/diet_recommendation/diet_recommender.dart';

import 'package:mood_tracker/screen/moodtracker/moodtrackfront.dart';
import 'package:mood_tracker/screen/moodtracker/moodtracklist.dart';
import 'package:mood_tracker/Accounts/welcome_screen.dart';
import 'package:mood_tracker/screen/report/report.dart';

import 'screen/cbt_track/formlist.dart';
import 'screen/Quiz/Anxietyquiz.dart';
//import 'mental_health /mentalhealthinfo.dart';
import 'screen/Pill_reminder/pill_reminder_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  Pill pill;

  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    'resource://mipmap/ic_launcher', // This refers to the default Flutter app icon
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        importance: NotificationImportance.High,
        playSound: true,
        enableLights: true,
        enableVibration: true,
      )
    ],
  );

  tz.initializeTimeZones();
  print("Current timezone: ${tz.local.name}");

  try {
    await Firebase.initializeApp();
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onNotificationActionReceived,
  );

  runApp(MyApp());
}

Future<void> onNotificationActionReceived(ReceivedAction receivedAction) async {
  print("Notification clicked! Payload: ${receivedAction.payload}");
  // Check the payload to determine the navigation logic
  if (receivedAction.payload != null &&
      receivedAction.payload!['page'] == 'Confirm') {
    print("Navigating to Confirm page...");
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => Confirm(),
    ));
  }
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? loggedInUser;
  String? userEmail;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => HomeScreen()
      },
      home: AuthGate(),
    );
  }
}

// class GET extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Health Assistant',
//       initialRoute: '/', // You can set an initial route if you need
//       getPages: [
//         // Define your routes here
//        , // Example of HomePage route
//         GetPage(
//             name: '/patient', page: () => Sendpatient()), // Patient page route
//       ],
//     );
//   }
// }

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          return HomeScreen(); // Replace with your home screen
        } else {
          return WelcomeScreen(); // Replace with your login/sign-up screen
        }
      },
    );
  }
}

class acccontrol extends StatelessWidget {
  const acccontrol({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

User? user = FirebaseAuth.instance.currentUser;

var emaill = '';
var id = '';

String? getCurrentUserId() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

class Drawers extends StatelessWidget {
  Drawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shadowColor: const Color.fromRGBO(68, 138, 255, 1),
        elevation: 1.0,
        backgroundColor: const Color.fromARGB(255, 168, 213, 247),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [buildheader(context), buildMenuItems(context)],
          ),
        ));
  }

  Widget buildheader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
    );
  }

  Widget buildMenuItems(context) {
    return Column(children: [
      SizedBox(height: 50),
      buildListTile(
          Icons.medical_information, 'DoctorView', RoleBasedView(), context),

      buildListTile(
          Icons.emoji_emotions, 'Health Assessment', Moodfront(), context),

      // buildListTile(
      //     Icons.newspaper, 'Mentalhealth Info ', mentalhinfo(), context),
      buildListTile(
          Icons.medication_outlined, 'Pill Reminder ', Pillremind(), context),
      buildListTile(
          Icons.newspaper, 'Health Assessment history ', Moodlist(), context),
      buildListTile(Icons.list, 'Doc List ', DoctorListScreen(), context),
      buildListTile(Icons.sick, 'Emergency', Call(), context),
      buildListTile(Icons.medical_information, 'Symptom Testing',
          Symptompredict(), context),
      buildListTile(Icons.medical_information, 'Diet Recommendation',
          DietRecommend(), context),
      buildListTile(
          Icons.feedback, 'Doctor Feedback ', FeedbackListScreen(), context),
      ExpansionTile(
        title: Text('Psycological Health'),
        children: <Widget>[
          buildListTile(Icons.note, 'CBT form ', Formlist(), context),
          buildListTile(
              Icons.healing, 'Anxiety Quiz ', AnxietyQuizApp(), context),
          buildListTile(Icons.healing, 'Depression Quiz ',
              DepressionQuizScreen(), context),
        ],
      ),
      //buildListTile(Icons.person_3_sharp, 'Doctors ', Doctors(), context),
      ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            // Perform logout action
            await FirebaseAuth.instance.signOut();

            // Navigate to WelcomeScreen and clear the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()),
              (Route<dynamic> route) =>
                  false, // Prevent going back to the previous page
            );
          })
    ]);
  }

  ListTile buildListTile(
      IconData icon, String home, var classes, var contexts) {
    return ListTile(
      leading: Icon(icon),
      title: Text(home),
      onTap: () {
        Navigator.of(contexts)
            .push(MaterialPageRoute(builder: (contexts) => classes));
      },
    );
  }
}
