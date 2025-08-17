
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/theme_cubit.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/task_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Todo'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            tooltip: 'Clear All',
            onPressed: () => context.read<TodoBloc>().add(ClearAllTodos()),
            icon: const Icon(Icons.delete_sweep),
          )
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.status == TodoStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Tap + to add.'));
          }
          return ListView.builder(
            itemCount: state.tasks.length,
            itemBuilder: (context, index) {
              final task = state.tasks[index];
              return TaskItem(task: task);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
            onSubmitted: (_) => _submit(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(text));
      _controller.clear();
      Navigator.of(context).pop();
    }
  }
}
