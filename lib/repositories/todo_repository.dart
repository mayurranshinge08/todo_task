import 'package:hive/hive.dart';

import '../models/task.dart';

class TodoRepository {
  static const String tasksBoxName = 'tasksBox';

  Future<Box<Task>> _openBox() async {
    if (Hive.isBoxOpen(tasksBoxName)) {
      return Hive.box<Task>(tasksBoxName);
    }
    return await Hive.openBox<Task>(tasksBoxName);
  }

  Future<List<Task>> fetchTasks() async {
    final box = await _openBox();
    return box.keys.map((key) {
      final task = box.get(key)!;
      return Task(id: key, title: task.title, isDone: task.isDone);
    }).toList();
  }

  Future<void> addTask(String title) async {
    final box = await _openBox();
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      isDone: false,
    );
    await box.put(task.id, task); // Hive auto-assigns an int key
  }

  Future<void> toggleComplete(int id) async {
    final box = await _openBox();
    final task = box.get(id);
    if (task != null) {
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        isDone: !task.isDone, // flip the value
      );
      await box.put(id, updatedTask); // save back
    }
  }

  Future<void> deleteTask(int id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
