import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late bool isCompleted;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  DateTime? dueTime;

  @HiveField(6)
  bool getReminder;

  Todo(
      this.title,
      this.description,
      this.isCompleted, {
        this.imagePath,
        this.dueDate,
        this.dueTime
        required this.getReminder,
      });
}