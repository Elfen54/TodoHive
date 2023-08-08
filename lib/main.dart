import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo_with_hive_db/screens/home_screen.dart'; // Update the path to the home_screen.dart file if needed
import 'package:todo_with_hive_db/models/todo_model.dart';

void main() async {
  // Initialize Hive
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Check if the 'todos' box is already open
  if(!Hive.isBoxOpen('todos')) {
    //Register HIve adapters and open boxes
    Hive.registerAdapter<Todo>(TodoAdapter());
    await Hive.openBox<Todo>('todos');
  }

  // RUn the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todo App',
      home: HomeScreen(),
    );
  }
}