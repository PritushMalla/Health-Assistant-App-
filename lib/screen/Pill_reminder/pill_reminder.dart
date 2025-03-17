import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mood_tracker/main.dart';
import 'package:mood_tracker/models/Pill_reminder/pill.dart';
import 'package:mood_tracker/screen/Pill_reminder/confirmreminder.dart';
import 'package:mood_tracker/screen/Pill_reminder/pill_reminder_home.dart';
import 'package:mood_tracker/utils/convert_time.dart';
import 'package:sizer/sizer.dart';
import 'package:mood_tracker/utils/pill_database/databasehelperp.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Reminder extends StatefulWidget {
  final Pill pill;
  const Reminder(
    this.pill, {
    super.key,
  });

  @override
  State<Reminder> createState() {
    // ignore: no_logic_in_create_state
    return _ReminderState(
      pill,
    );
  }
}

class _ReminderState extends State<Reminder> {
  final location = tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
  late DateTime scheduleTime;
  String buttonText = 'Pick a time for notification';
  //late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DatabaseHelper_pill pilldatabasehelper = DatabaseHelper_pill();
  final Pill pill;
  late String type;
  late String time;
  int? hour;
  int? minute;

  final namecontroller = TextEditingController();
  final dosecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final List<int> _intervals = [1, 3, 5, 8, 10];
  int? selecteditem;
  bool _pillselected = false;
  bool _medicineselected = false;
  bool _syringeselected = false;
  bool _tabletselected = false;
  bool _timeclicked = false;
  TimeOfDay _time = const TimeOfDay(hour: 0, minute: 00);

  _ReminderState(this.pill);

  Future<TimeOfDay?> _selectedTime() async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _timeclicked = true;
      });
    }
    return picked;
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    namecontroller.text = pill.Mname;
    dosecontroller.text = pill.dose;
    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initializeNotification();
  }

  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Reminder'),
      ),
      drawer: Drawers(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              textsfield('Medicine Name', namecontroller, TextInputType.text),
              SizedBox(height: 20),
              textsfield('Medicine Dose (in mg/gram)', dosecontroller,
                  TextInputType.number),
              SizedBox(height: 40),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Medicine Type")),
              SizedBox(height: 20),
              Row(
                children: [
                  Medicine_Checker("assets/images/Pill.png", _pillselected, () {
                    setState(() {
                      _pillselected = !_pillselected;
                      _medicineselected = false;
                      _syringeselected = false;
                      _tabletselected = false;
                      this.type = "Pill";
                    });
                  }, "Pill"),
                  SizedBox(
                    width: 10,
                  ),
                  Medicine_Checker(
                      "assets/images/Bottled.png", _medicineselected, () {
                    setState(() {
                      _medicineselected = !_medicineselected;
                      _pillselected = false;
                      _tabletselected = false;
                      _syringeselected = false;
                      this.type = "Bottled";
                      // To ensure only one is selected
                    });
                  }, "Bottled"),
                  SizedBox(
                    width: 10,
                  ),
                  Medicine_Checker(
                      "assets/images/Syringe.png", _syringeselected, () {
                    setState(() {
                      _syringeselected = !_syringeselected;
                      _medicineselected = false;
                      _pillselected = false;
                      _tabletselected = false;
                      this.type = "Syringe";
                    });
                  }, "Syringe"),
                  SizedBox(
                    width: 10,
                  ),
                  Medicine_Checker("assets/images/Tablet.png", _tabletselected,
                      () {
                    setState(() {
                      _tabletselected = !_tabletselected;
                      _syringeselected = false;
                      _pillselected = false;
                      _medicineselected = false;
                      this.type = "Tablet";
                    });
                  }, "Tablet")
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Interval Selection \nRemind me Every "),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 5),
                    child: DropdownButton<int>(
                        hint: Text('Select an interval'),
                        value: selecteditem,
                        items:
                            _intervals.map<DropdownMenuItem<int>>((int item) {
                          return DropdownMenuItem<int>(
                              value: item, child: Text(item.toString()));
                        }).toList(),
                        onChanged: (newval) {
                          setState(() {
                            selecteditem = newval;
                          });
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 5),
                    child: Text("hours"),
                  )
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    //_selectedTime();
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      onChanged: (date) {
                        scheduleTime = date;
                        print('onChanged: $scheduleTime');
                      },
                      onConfirm: (date) {
                        setState(() {
                          scheduleTime = date;
                          var timehour = scheduleTime.hour;
                          var timemin = scheduleTime.minute;
                          buttonText = 'Scheduled for $timehour: $timemin';
                        });
                        print('onConfirm: $scheduleTime');
                      },
                    );
                    hour = scheduleTime.hour;
                    minute = scheduleTime.minute;
                  },
                  child: Text(buttonText)),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState!.validate()) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text("Submitting Data ")));
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //       content: Text("All fields are required !")));
                  // }
                  _save(hour, minute);
                },
                child: Text("Confirm"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton Medicine_Checker(
      var buttonimage, bool selection, var onPressed, String type) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage(buttonimage),
              ),
            ),
            width: 0.7.inches,
            height: 0.7.inches,
          ),
          Text(type),
        ],
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: selection
              ? const Color.fromARGB(255, 127, 184, 230)
              : const Color.fromARGB(
                  255, 207, 206, 206), // Selected/Unselected color
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)) // Button size,),
          ),
    );
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload:$payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Confirm()));
  }

  int generateNofiid() {
    return DateTime.now().microsecondsSinceEpoch;
  }

  Future<void> scheduleNotification(Pill pill) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastNotifDate = prefs.getString('last_notification_date');

    String todayDate =
        DateTime.now().toIso8601String().substring(0, 10); // Format: YYYY-MM-DD

    // Check if a notification has already been sent today
    if (lastNotifDate == todayDate) {
      print('Notification already sent today. Skipping...');
      return;
    }

    // Save today's date as the last notification date
    await prefs.setString('last_notification_date', todayDate);

    var notifid = generateNofiid();
    var hour = int.parse(pill.time![0] + pill.time[1]);
    var ogvalue = hour;
    var minute = int.parse(pill.time![2] + pill.time[3]);
    // var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    //     'repeatDailyAtTime channel id ', 'epeatDailyAtTime channel name',
    //     importance: Importance.max, enableLights: true);
    // var iOSPlatoformChannelSpecifics = const DarwinNotificationDetails();
    // var platformChannelSpecifics = NotificationDetails(
    //     android: androidPlatformChannelSpecifics,
    //     iOS: iOSPlatoformChannelSpecifics);

    var interval = int.parse(pill.Minterval);

    // to run after every interval

    for (int i = 0; i < (24 / interval).floor(); i++) {
      // Calculate the scheduled time
      DateTime notificationTime =
          DateTime.now().add(Duration(hours: interval * i));

      // Adjust the hour based on the interval, making sure the time stays within a 24-hour period
      int adjustedHour = (hour + interval * i) % 24;

      // For the moment, we are assuming the minute remains constant
      int notificationMinute = minute;

      // Create the notification time using timezone aware DateTime
      final tzDateTime = tz.TZDateTime.local(
          notificationTime.year,
          notificationTime.month,
          notificationTime.day,
          adjustedHour,
          notificationMinute);

      // await flutterLocalNotificationsPlugin.zonedSchedule(
      //   notifid,
      //   'Reminder:${pill.Mname}',
      //   'It is time to take your ${pill.Mname}',
      //   tz.TZDateTime.from(notificationTime, tz.local),
      //   platformChannelSpecifics,
      //   uiLocalNotificationDateInterpretation:
      //       UILocalNotificationDateInterpretation.absoluteTime,
      // );
    }
  }

  TextFormField textsfield(String text, var controllers, TextInputType type) =>
      TextFormField(
          controller: controllers,
          decoration: InputDecoration(
              labelText: text,
              labelStyle: new TextStyle(color: Colors.blueGrey)),
          keyboardType: type,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required ';
            }
            return null;
          });

  void _save(int? hour, int? minute) async {
    requestNotificationPermission();
    // requestPermission();

    pilldetail() {
      pill.Mname = namecontroller.text;
      pill.dose = dosecontroller.text;
      pill.Mtype = type;
      pill.time = scheduleTime.toString();
      pill.Minterval = selecteditem.toString();
    }

    if (scheduleTime != null) {
      int displayhour = scheduleTime.hour;
      int displaymin = scheduleTime.minute;
      try {
        // Schedule notification using Awesome Notifications
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'basic_channel',
              title: 'Scheduled Notification',
              body: 'Reminder : Please take your meds on time ',
              payload: {'page': 'Confirm'}),
          schedule: NotificationCalendar(
              hour: hour,
              minute: minute,
              second: 0,
              repeats: false,
              timeZone: 'Asia/Kathmandu'

              // Ensure the notification repeats daily
              ),
        );

        print('Time to take your Pill');
      } catch (e) {
        print("Error scheduling notification: $e");
      }
    } else {
      print("No time selected!");
    }
    pilldetail();

    int? result;
    try {
      if (pill.id == null) {
        result = await pilldatabasehelper.insertpill(pill);
      } else {
        result = await pilldatabasehelper.updatepill(pill);
      }

      if (result != 0) {
        Navigator.pop(context, true);
        _showAlertDialog('Status', 'Pill  saved successfully');
        scheduleNotification(pill);
      } else {
        _showAlertDialog('Status', 'Error saving pill');
      }
    } catch (e) {
      print('Error saving mood: $e'); // Log the error
      _showAlertDialog('Status', 'Error saving pill: $e');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  Future<void> requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Request permissions if not allowed
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }
//   Future<void> requestPermission() async {
//     if (Platform.isAndroid) {
//       final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
//           flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>();
//       await androidPlugin?.requestNotificationsPermission();
//     }
//  }
}
