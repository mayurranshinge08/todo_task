import 'package:equatable/equatable.dart';
import 'package:todo_app/bloc/todo_event.dart';

import '../models/todo.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoLoaded({required this.todos, this.filter = TodoFilter.all});

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((todo) => !todo.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((todo) => todo.isCompleted).toList();
      case TodoFilter.all:
      default:
        return todos;
    }
  }

  int get completedTodosCount => todos.where((todo) => todo.isCompleted).length;
  int get activeTodosCount => todos.where((todo) => !todo.isCompleted).length;

  TodoLoaded copyWith({List<Todo>? todos, TodoFilter? filter}) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object> get props => [todos, filter];
}

class TodoError extends TodoState {
  final String message;

  const TodoError({required this.message});

  @override
  List<Object> get props => [message];
}
