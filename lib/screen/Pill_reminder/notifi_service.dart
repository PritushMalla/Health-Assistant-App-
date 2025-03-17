//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications_web_interface.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  // final FlutterLocalNotificationsPlugin notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
//  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
  NotificationService() {
    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Set the local location to your device's timezone
      final String currentTimeZone = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation('Asia/Kathmandu'));
      print("currenttimezone is  $currentTimeZone");
    } catch (e) {
      print("error:$e");
    }
  }

  // Future<void> requestPermission() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
  //           notificationsPlugin.resolvePlatformSpecificImplementation<
  //               AndroidFlutterLocalNotificationsPlugin>();

  //       await androidPlugin?.requestNotificationsPermission();
  //       final result = await androidPlugin?.requestExactAlarmsPermission();

  //       if (result != null && result) {
  //         print('Notification permission granted');
  //       } else {
  //         print('Notification permission denied');
  //       }
  //     }
  //   } catch (e) {
  //     print("error$e");
  //   }
}

// Future<void> initState() async {
//   try {
//     if (Platform.isAndroid) {
//       const AndroidNotificationChannel channel = AndroidNotificationChannel(
//         'channelId', // Replace with your channel ID
//         'channelName', // Replace with your channel name
//         description: "Description", // Channel description
//         importance: Importance.max,

//         playSound: true,
//       );
//       print(channel);
//       await notificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);

//       AndroidInitializationSettings initializationSettingsAndroid =
//           const AndroidInitializationSettings('@mipmap/ic_launcher');
//       print(initializationSettingsAndroid.defaultIcon);
//       var initializationSettingsIOS = DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           onDidReceiveLocalNotification:
//               (int id, String? title, String? body, String? payload) {});

//       var initializationSettings = InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS);
//       var notifplugininitialis = await notificationsPlugin.initialize(
//           initializationSettings,
//           onDidReceiveNotificationResponse:
//               (NotificationResponse notificationResponse) {});
//       print(" notif initialise:$notifplugininitialis");
//     }
//   } catch (e) {
//     print("error:$e");
//   }
// }

// Future<NotificationDetails> notificationDetails() async {
//   return NotificationDetails(
//     android: AndroidNotificationDetails('channelId', 'channelName',
//         channelDescription: "Description",
//         priority: Priority.max,
//         importance: Importance.max,
//         icon: '@mipmap/ic_launcher'),
//     iOS: DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     ),
//   );
// }

Future<void> scheduleDailyNotification(int hour, int minute) async {
  try {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    // Create the scheduled time for today (or tomorrow if it has already passed)
    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    // If the scheduled time has already passed today, schedule it for the next day
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Medication Reminder',
        body: 'It\'s time to take your medication',
      ),
      schedule: NotificationCalendar(
          hour: hour,
          minute: minute,
          second: 0,
          repeats: false,
          preciseAlarm: true
          // Repeat every day
          ),
    );
    print("Notification scheduled for $hour:$minute every day.");
  } catch (e) {
    print("Error scheduling notification: $e");
  }

  List<NotificationModel> scheduledNotifications =
      await AwesomeNotifications().listScheduledNotifications();
  print('Scheduled Notifications: ${scheduledNotifications.length}');
}
// Future showNotification(
//     {int id = 0, String? title, String? body, String? payLoad}) async {
//   print("show notif called ");
//   await notificationsPlugin.show(id, title, body, notificationDetails());
// }

tz.TZDateTime _nextInstanceOfNotification(DateTime scheduleTime) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

  tz.TZDateTime scheduledDate =
      tz.TZDateTime.from(scheduleTime.toLocal(), tz.local);
  print("Converted Scheduled Time (Local TZ): $scheduledDate");
  // If the time has passed, schedule for the next day
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(Duration(days: 1));
  }
  print(" instanceofnotif at $scheduledDate");
  print("Current time: ${tz.TZDateTime.now(tz.local)} (Local)");
  print("Scheduled time: $scheduledDate (Local)");
  print("Scheduled time UTC: ${scheduledDate.toUtc()}");
  return scheduledDate;
}

Future<void> requestNotificationPermission() async {
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // Request permissions if not allowed
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

Future<void> NotifScheduler(
    {int id = 0,
    String? title,
    String? body,
    String? payLoad,
    required DateTime schedule}) async {
  tz.TZDateTime scheduleTime = _nextInstanceOfNotification(schedule);

  if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
    print("Scheduled time must be in the future");
    // Don't schedule if the time is in the past
  } else
    print(
        'Scheduling notification with id: $id, title: $title, body: $body, scheduled time: $scheduleTime');
  print(
      "Scheduling notification for: ${_nextInstanceOfNotification(scheduleTime)}");

  //try {
  // await notificationsPlugin.zonedSchedule(
  //     0, title, body, scheduleTime, await notificationDetails(),
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidScheduleMode: AndroidScheduleMode.exact);

  //   print("THE NOTIF DETAIL ARE$notificationDetails()");
  // } catch (e) {
  //   print("error: $e");
  // }
  print("notif scheduled");
  print(
      'Scheduling notification for ${scheduleTime.hour}:${scheduleTime.minute} every day.');
  print("Notification scheduled for: $scheduleTime");
  print("Notification scheduled for: $scheduleTime (Local TZ)");
}
