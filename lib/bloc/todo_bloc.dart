import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/todo_repository.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(const TodoState()) {
    on<LoadTodos>(_onLoad);
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggle);
    on<DeleteTodo>(_onDelete);
    on<ClearAllTodos>(_onClearAll);
  }

  Future<void> _onLoad(LoadTodos event, Emitter<TodoState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));
    try {
      final tasks = await repository.fetchTasks();
      emit(state.copyWith(status: TodoStatus.success, tasks: tasks));
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.failure));
    }
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    await repository.addTask(event.title); // save task in Hive
    final tasks = await repository.fetchTasks(); // get fresh list
    emit(state.copyWith(tasks: tasks)); // tell UI to update
  }

  Future<void> _onToggle(ToggleTodo event, Emitter<TodoState> emit) async {
    await repository.toggleComplete(event.id);
    add(LoadTodos());
  }

  Future<void> _onDelete(DeleteTodo event, Emitter<TodoState> emit) async {
    await repository.deleteTask(event.id);
    add(LoadTodos());
  }

  Future<void> _onClearAll(ClearAllTodos event, Emitter<TodoState> emit) async {
    await repository.clearAll();
    add(LoadTodos());
  }
}
