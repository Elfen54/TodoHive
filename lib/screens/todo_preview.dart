import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class TodoPreview extends StatelessWidget {
  final Todo todo;

  const TodoPreview({super.key, required this.todo});

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      // 'channel_description',
      importance: Importance.high,
    );
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.show(
        0,  // Notification ID
        'Todo Reminder', // Title
        'Don\'t forget about your todo!', // Body
        notificationDetails,
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
      ? DateFormat('hh:mm a').format(todo.dueTime!)
      : 'N/A';

    return AlertDialog(
      title: Text(todo.title),
      content: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            const SizedBox(height: 8.0),
            Text('More Details : ${todo.imagePath ?? 'N/A'}'), // Displaying imgPath or 'N/A' if null
            Text('Due Date : $formattedDueDate'),
            Text('Due Time : $formattedDueTime'),
            Text('Get Reminder : ${todo.getReminder ? 'Yes' : 'No'}'),
            Checkbox(
                value: todo.getReminder,
                onChanged: (value) async{
                  // Update the reminder status of the todo item
                  todo.getReminder = value!;
                  todo.save();

                  if (value) {
                    _showNotification();
                  }
                }
            )
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