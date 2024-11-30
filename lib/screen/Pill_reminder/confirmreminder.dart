import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirm extends StatelessWidget {
  const Confirm({super.key});

  @override
  Widget build(BuildContext context) {
    int notificationId = 1;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  showConfirmationDialog(context, notificationId);
                },
                child: Text("Have you taken your Pill today ?"))
          ],
        ),
      ),
    );
  }

  Future<void> showConfirmationDialog(
      BuildContext context, int notificationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Pill Intake'),
          content: Text('Have you taken your pill for today?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Mark as confirmed and cancel the notification
                await confirmPill(notificationId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmPill(int notificationId) async {
    // Perform any logic to mark the pill as confirmed (e.g., update database)
    print('Pill confirmed for notification ID: $notificationId');

    // Cancel today's notification
    await AwesomeNotifications().cancelSchedule(notificationId);
  }
}
