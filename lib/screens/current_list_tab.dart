import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Todo>('todos').listenable(),
      builder: (context, Box<Todo> box, _) {
        // Get the list of todo items that are not completed
        final currentList = box.values.where((todo) => !todo.isCompleted).toList();

        if (currentList.isEmpty) {
          // If there are no items in the current list, show a message
          return const Center(
            child: Text('No items in the current list.',
            style: TextStyle(fontSize: 24),
            ),
          );
        } else {
          // If there are items in the current list, display them in a ListView
          return ListView.builder(
            itemCount: currentList.length,
            itemBuilder: (context, index) {
              final todo = currentList[index];
              return ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    // When the checkbox is toggled, update the completion status of the todo item
                    todo.isCompleted = value!;
                    todo.save();
                  },
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description),
                // Add more UI elements to display other properties of the todo item
                // (e.g., due date, due time, etc.) here
              );
            },
          );
        }
      },
    );
  }
}
