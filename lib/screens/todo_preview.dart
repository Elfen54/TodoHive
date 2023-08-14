import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TodoPreview extends StatelessWidget {
  final Todo todo;

  const TodoPreview({Key? key, required this.todo}) : super(key: key);

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      //'channel_description',
      importance: Importance.high,
    );
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Todo Reminder', // Title
      "Don't forget about your todo!", // Body
      tz.TZDateTime.from(todo.dueDate!.add(Duration(hours: todo.dueTime!.hour, minutes: todo.dueTime!.minute)), tz.local), // Schedule time
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Format the dueDate using DateFormat
    String formattedDueDate = todo.dueDate != null
        ? DateFormat('dd-MM-yyyy').format(todo.dueDate!)
        : 'N/A';
    // Format dueTIme using TimeOfDay properties
    String formattedDueTime = todo.dueTime != null
        ? DateFormat('hh:mm a').format(DateTime(0, 0, 0, todo.dueTime!.hour, todo.dueTime!.minute))
        : 'N/A';

    return AlertDialog(
      title: Text(todo.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            const SizedBox(height: 8.0),
            Text('More Details : ${todo.imagePath ?? 'N/A'}'),
            // Displaying imgPath or 'N/A' if null
            Text('Due Date : $formattedDueDate'),
            Text('Due Time : $formattedDueTime'),
            //Text('Get Reminder : ${todo.getReminder ? 'Yes' : 'No'}'),
            Row( // Wrap in a Row to align Get Reminder text and Checkbox
              children: [
                Text('Get Reminder : ${todo.getReminder ? 'Yes' : 'No'}'),
                const SizedBox(width: 8.0),
                Checkbox(
                  value: todo.getReminder,
                  onChanged: null,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
