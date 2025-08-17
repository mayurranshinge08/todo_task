
import '../models/task.dart';

enum TodoStatus { initial, loading, success, failure }

class TodoState {
  final TodoStatus status;
  final List<Task> tasks;

  const TodoState({
    this.status = TodoStatus.initial,
    this.tasks = const [],
  });

  TodoState copyWith({
    TodoStatus? status,
    List<Task>? tasks,
  }) {
    return TodoState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
    );
  }
}
