import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  // Create Text Editing Controller for each form field
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  bool _getReminder = false;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imagePathController.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo Item'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Add Image/Take Photo'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Date: '),
                ElevatedButton(
                  onPressed: () async {
                    //Show a date picker when the button is pressed
                    final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (pickedDate != null && pickedDate != _dueDate) {
                      setState(() {
                        _dueDate = pickedDate;
                      });
                    }
                  },
                  child: Text(_dueDate != null ? '$_dueDate' : 'Select Date'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Time: '),
                ElevatedButton(
                    onPressed: () async {
                      //Show a time picker when the button is pressed
                      final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                      );
                      if(pickedTime != null && pickedTime != _dueTime) {
                        setState(() {
                          _dueTime = pickedTime;
                        });
                      }
                    },
                    child: Text(_dueTime != null ? '${_dueTime!.hour}:${_dueTime!.minute}' : 'Select TIme'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Get Reminder: '),
                Checkbox(
                    value: _getReminder,
                    onChanged: (value) {
                      setState(() {
                        _getReminder = value!;
                      });
                    },
                  ),
              ],
            ),
            /// Elevated Buttons
            ElevatedButton(
                onPressed: () {
                  // When the Save button is pressed, save the new todo item to the Hive box
                  final todoBox = Hive.box<Todo>('todos');
                  final newTodo = Todo (
                    _titleController.text,
                    _descriptionController.text,
                    false, //isCompleted is set to false for new todo items
                    imagePath: _imagePathController.text,
                    dueDate: _dueDate,
                    dueTime: _dueTime != null ? DateTime(0,0,0, _dueTime!.hour, _dueTime!.minute) : null,
                    getReminder: _getReminder,
                  );
                  todoBox.add(newTodo);
                  Navigator.pop(context); //Close the AddTodoScreen
                },
                child:const Text('Save'),
            ),
            ElevatedButton(
                onPressed: () {
                  // When the clear button is pressed, clear all the form fields
                  _titleController.clear();
                  _descriptionController.clear();
                  _imagePathController.clear();
                  setState(() {
                    _getReminder = false;
                    _dueDate = null;
                    _dueTime = null;
                  });
                },
                child: const Text('Clear'),
            ),
            ElevatedButton(
                onPressed: () {
                  // When the Cancel button is pressed, Navigate back to the HomeScreen
                  Navigator.pop(context);
                },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}