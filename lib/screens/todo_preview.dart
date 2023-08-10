import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo_model.dart';

class TodoPreview extends StatelessWidget {
  final Todo todo;

  TodoPreview({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {

    // Format the dueDate using DateFormat
    String formattedDueDate = todo.dueDate != null
      ? DateFormat('dd-MM-yyyy').format(todo.dueDate!)
      : 'N/A';
    // Format dueTIme using TimeOfDay properties
    String formattedDueTime = todo.dueTime != null
      ? '${todo.dueTime!.hour}:${todo.dueTime!.minute}'
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