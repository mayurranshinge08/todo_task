
import '../models/task.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  AddTodo(this.title);
}

class ToggleTodo extends TodoEvent {
  final int id;
  ToggleTodo(this.id);
}

class DeleteTodo extends TodoEvent {
  final int id;
  DeleteTodo(this.id);
}

class ClearAllTodos extends TodoEvent {}
