import 'package:equatable/equatable.dart';

import '../models/todo.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;

  const AddTodo({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

class UpdateTodo extends TodoEvent {
  final Todo todo;

  const UpdateTodo({required this.todo});

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String id;

  const DeleteTodo({required this.id});

  @override
  List<Object> get props => [id];
}

class ToggleTodo extends TodoEvent {
  final String id;

  const ToggleTodo({required this.id});

  @override
  List<Object> get props => [id];
}

class FilterTodos extends TodoEvent {
  final TodoFilter filter;

  const FilterTodos({required this.filter});

  @override
  List<Object> get props => [filter];
}

enum TodoFilter { all, active, completed }
