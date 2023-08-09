import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import 'home_screen.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo todo; //Pass the selected item to the screen

  EditTodoScreen({super.key, required this.todo});

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagePathController;
  bool _getReminder = false;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;

  bool _validate = false; // Add Validation flag

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the selected todo item's details
    _titleController = TextEditingController(text: widget.todo.title);
    _descriptionController = TextEditingController(text: widget.todo.description);
    _imagePathController = TextEditingController(text: widget.todo.imagePath);
    _getReminder = widget.todo.getReminder;
    _dueDate = widget.todo.dueDate;
    _dueTime = widget.todo.dueTime != null
      ? TimeOfDay.fromDateTime(widget.todo.dueTime!)
      : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo Item'),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  errorText: _validate ? 'Title can\'t be Empty' : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Info'), //Image path is Text field for new.
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due Date: '),
                ElevatedButton(
                    onPressed: () async {
                      // Show a date picker when the button is pressed
                      final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _dueDate = pickedDate;
                        });
                      }
                    }, 
                    child: Text(_dueDate != null ? '$_dueDate' : 'Select Date'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Due TIme: '),
                ElevatedButton(
                    onPressed: () async {
                      // Show a time picker when the button is pressed
                      final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: _dueTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _dueTime = pickedTime;
                        });
                      }
                    },
                    child: Text(
                      _dueTime != null
                          ? '${_dueTime!.hour}:${_dueTime!.minute}'
                          : 'Select Time',
                    ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

            const SizedBox(height: 16),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // Navigate Back to the Previous screen without saving
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _titleController.text.trim().isEmpty
                          ? _validate = true
                          : _validate = false;
                    });

                    if (_titleController.text.trim().isNotEmpty) {
                      // Implement logic to update the selected todo item
                      // Update the todo item's properties using the controllers
                      widget.todo.title = _titleController.text;
                      widget.todo.description = _descriptionController.text;
                      widget.todo.imagePath = _imagePathController.text;
                      widget.todo.dueDate = _dueDate;
                      widget.todo.dueTime = _dueTime != null
                          ? DateTime(0,0,0, _dueTime!.hour, _dueTime!.minute)
                          : null;
                      widget.todo.getReminder = _getReminder;

                      widget.todo.save(); // Save changes to the data Store
                      Navigator.pop(context); // Return to previous screen
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    // Dispose other controllers
    super.dispose();
  }
}