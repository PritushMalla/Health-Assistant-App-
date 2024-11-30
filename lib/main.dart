import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:mood_tracker/Accounts/Signup.dart';
import 'package:mood_tracker/Accounts/login.dart';
import 'package:mood_tracker/Accounts/logout.dart';
import 'package:mood_tracker/Home.dart';
import 'package:mood_tracker/models/Pill_reminder/pill.dart';
import 'package:mood_tracker/screen/Admin/Admin_prof_list.dart';
import 'package:mood_tracker/screen/Doctors/Doctors.dart';
import 'package:mood_tracker/screen/Pill_reminder/confirmreminder.dart';
import 'package:mood_tracker/screen/Quiz/Depressionquiz.dart';

import 'package:mood_tracker/screen/moodtracker/moodtrackfront.dart';
import 'package:mood_tracker/screen/moodtracker/moodtracklist.dart';
import 'package:mood_tracker/Accounts/welcome_screen.dart';

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
    return MaterialApp(
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
//
// class AppLanding extends StatefulWidget {
//   const AppLanding({Key? key}) : super(key: key);

// @override
// State<AppLanding> createState() => _AppLandingState();
// }
// DatabaseHelper databaseHelper=DatabaseHelper();
//class _AppLandingState extends State<AppLanding> {
//   int _selectedIndex = 0;
//
//
//
//
//
//
//
// //   List<Widget> pages = [
// //   Drawers(),
// //     moody(),
// //     Formlist(),
// //   ];
// // Formlist formlist2=Formlist();
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //
// //         title: const Text('Mental health'),
// //       ),
// //       body:
// //
// //
// //
// //
// //       pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: (value) {
// //           setState(() {
// //             _selectedIndex = value;
// //           });
// //         },
// //         items: <BottomNavigationBarItem>[
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.home),
// //             label: 'Home',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.people),
// //             label: 'CBT form ',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.note),
// //             label: 'Quiz',
// //           )
// //         ],
// //         unselectedItemColor: Colors.black,
// //         selectedItemColor: Colors.blue,
// //       ),
// //     );
// //
// //
// //
// //
// //   }
//
//

//
//}

class Drawers extends StatelessWidget {
  const Drawers({super.key});

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
          Icons.emoji_emotions, 'Mood Assessment', Moodfront(), context),
      buildListTile(Icons.note, 'CBT form ', Formlist(), context),

      // buildListTile(
      //     Icons.newspaper, 'Mentalhealth Info ', mentalhinfo(), context),
      buildListTile(Icons.newspaper, 'Pill Reminder ', Pillremind(), context),
      buildListTile(Icons.newspaper, 'Mood history ', Moodlist(), context),
      ExpansionTile(
        title: Text('Quizzes'),
        children: <Widget>[
          buildListTile(
              Icons.healing, 'Anxiety Quiz ', AnxietyQuizApp(), context),
          buildListTile(Icons.healing, 'Depression Quiz ',
              DepressionQuizScreen(), context),
        ],
      ),
      // buildListTile(Icons.sick, 'Emergency Hotline ', Emergency(), context),

      FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Define the admin email
            final String adminEmail = 'pritushmalla@gmail.com';
            final userEmail = snapshot.data?.email;

            // Show Admin Page only for admin
            if (userEmail == adminEmail) {
              return buildListTile(
                Icons.sick,
                'Admin Page',
                Proflist(),
                context,
              );
            }
          }
          // Return an empty container if not admin
          return Container();
        },
      ),
      //Proflist
      buildListTile(Icons.person_3_sharp, 'Doctors ', Doctors(), context),
      buildListTile(
          Icons.person_3_sharp, 'Login/SignUp ', WelcomeScreen(), context),

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
