import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CompletedTab extends StatefulWidget {
  @override
  _CompletedTabState createState() => _CompletedTabState();
}

class _CompletedTabState extends State<CompletedTab> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Todo>('todos').listenable(),
      builder: (context, Box<Todo> box, _) {
        // Get the list of todo items that are completed
        final completedList = box.values.where((todo) => todo.isCompleted).toList();

        if (completedList.isEmpty) {
          // If there are no completed items, show a message
          return const Center(
              child: Text('No items in the current list.',
              style: TextStyle(fontSize: 24),
              ),
          );
        } else {
          // If there are completed items, display them in a ListView
          return ListView.builder(
            itemCount: completedList.length,
            itemBuilder: (context, index) {
              final todo = completedList[index];
              return ListTile(
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      // Toggle the completion status
                      todo.isCompleted = !todo.isCompleted;
                      todo.save();

                      // If unchecked, move the todo item back to the Current list.
                      if(!todo.isCompleted) {
                        final currentListBox = Hive.box<Todo>('todos');
                        currentListBox.add(todo);
                      }
                    });
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
