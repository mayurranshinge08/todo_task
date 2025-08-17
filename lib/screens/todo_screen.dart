import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../utils/constants.dart';
import '../widgets/add_todo_dailog.dart';
import '../widgets/todo_item.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          PopupMenuButton<TodoFilter>(
            onSelected: (filter) {
              context.read<TodoBloc>().add(FilterTodos(filter: filter));
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(value: TodoFilter.all, child: Text('All')),
                  PopupMenuItem(
                    value: TodoFilter.active,
                    child: Text('Active'),
                  ),
                  PopupMenuItem(
                    value: TodoFilter.completed,
                    child: Text('Completed'),
                  ),
                ],
          ),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            final todos = state.filteredTodos;

            if (todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No todos yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add a todo to get started',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  color: AppColors.primary.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Total', state.todos.length.toString()),
                      _buildStatCard(
                        'Active',
                        state.activeTodosCount.toString(),
                      ),
                      _buildStatCard(
                        'Completed',
                        state.completedTodosCount.toString(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(todo: todos[index]);
                    },
                  ),
                ),
              ],
            );
          } else if (state is TodoError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TodoBloc>().add(LoadTodos());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddTodoDialog());
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
