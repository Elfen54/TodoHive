import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_with_hive_db/screens/edit_todo.dart';
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
                    if (value == false) {
                      // Show confirmation Dialog
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text('Are you sure you want this Todo item to return to Current List?'),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('No'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // CLose the dialog
                                      setState(() {
                                        // Toggle the completion status
                                        todo.isCompleted = false;
                                        todo.save();

                                        // Move the todo item back to the "Current List"
                                        final currentListBox = Hive.box<Todo>('todos');
                                        currentListBox.add(todo);
                                      });
                                    }, child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                      );
                    } else {
                      // Toggle the completion status
                      todo.isCompleted = true;
                      todo.save();
                    }
                  },
                ),
                title: Text(todo.title),
                subtitle: Text(todo.description),
                // Add more UI elements to display other properties of the todo item
                // (e.g., due date, due time, etc.) here
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Navigate to EditTodoScreen with the selected todo items details
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditTodoScreen(todo: todo),
                            ),
                        );
                      },
                      icon: const Icon(Icons.edit), // Add the Edit icon here
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final todoBox = Hive.box<Todo>('todos');
                        todoBox.delete(todo.key);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
