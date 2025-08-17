import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/todo_event.dart';
import 'package:todo_app/bloc/todo_state.dart';

import '../models/todo.dart';
import '../repositories/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc(this._todoRepository) : super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<FilterTodos>(_onFilterTodos);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoLoaded(todos: todos));
    } catch (e) {
      emit(TodoError(message: e.toString()));
    }
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    print('[DEBUG] TodoBloc: AddTodo event received');
    print(
      '[DEBUG] Title: "${event.title}", Description: "${event.description}"',
    );

    if (state is TodoLoaded) {
      try {
        final todo = Todo(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.title,
          description: event.description,
          createdAt: DateTime.now(),
        );

        print('[DEBUG] Created todo with ID: ${todo.id}');

        await _todoRepository.addTodo(todo);
        print('[DEBUG] Todo saved to repository');

        final updatedTodos = List<Todo>.from((state as TodoLoaded).todos)
          ..add(todo);
        emit((state as TodoLoaded).copyWith(todos: updatedTodos));

        print('[DEBUG] State updated with ${updatedTodos.length} todos');
      } catch (e) {
        print('[DEBUG] Error adding todo: $e');
        emit(TodoError(message: e.toString()));
      }
    } else {
      print(
        '[DEBUG] State is not TodoLoaded, current state: ${state.runtimeType}',
      );
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await _todoRepository.updateTodo(event.todo);
        final updatedTodos =
            (state as TodoLoaded).todos.map((todo) {
              return todo.id == event.todo.id ? event.todo : todo;
            }).toList();
        emit((state as TodoLoaded).copyWith(todos: updatedTodos));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        await _todoRepository.deleteTodo(event.id);
        final updatedTodos =
            (state as TodoLoaded).todos
                .where((todo) => todo.id != event.id)
                .toList();
        emit((state as TodoLoaded).copyWith(todos: updatedTodos));
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    }
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      try {
        final todoIndex = (state as TodoLoaded).todos.indexWhere(
          (todo) => todo.id == event.id,
        );
        if (todoIndex != -1) {
          final todo = (state as TodoLoaded).todos[todoIndex];
          final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
          await _todoRepository.updateTodo(updatedTodo);

          final updatedTodos = List<Todo>.from((state as TodoLoaded).todos);
          updatedTodos[todoIndex] = updatedTodo;
          emit((state as TodoLoaded).copyWith(todos: updatedTodos));
        }
      } catch (e) {
        emit(TodoError(message: e.toString()));
      }
    }
  }

  void _onFilterTodos(FilterTodos event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      emit((state as TodoLoaded).copyWith(filter: event.filter));
    }
  }
}
