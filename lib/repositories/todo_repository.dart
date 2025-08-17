import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodoRepository {
  static const String _todosKey = 'todos';

  Future<List<Todo>> getTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString(_todosKey);

      if (todosJson == null) return [];

      final List<dynamic> todosList = json.decode(todosJson);
      return todosList.map((json) => Todo.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      final todos = await getTodos();
      todos.add(todo);
      await _saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      final todos = await getTodos();
      final index = todos.indexWhere((t) => t.id == todo.id);

      if (index != -1) {
        todos[index] = todo;
        await _saveTodos(todos);
      } else {
        throw Exception('Todo not found');
      }
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final todos = await getTodos();
      todos.removeWhere((todo) => todo.id == id);
      await _saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = json.encode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_todosKey, todosJson);
  }
}
