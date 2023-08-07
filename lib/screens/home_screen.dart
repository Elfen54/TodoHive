import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/todo_model.dart';
import 'completed_tab.dart';
import 'current_list_tab.dart';
import 'package:todo_with_hive_db/screens/add_todo_screen.dart'; // Import the add_todo_screen.dart


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current List'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentListTab(),
            CompletedTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // When the FAB is pressed, navigate to the AddTodoScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTodoScreen()),
            );
          },
          tooltip: 'Add a todo item',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}