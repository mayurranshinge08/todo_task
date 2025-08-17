import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../utils/constants.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Todo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              autofocus: true,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addTodo,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: Text('Add Todo'),
        ),
      ],
    );
  }

  void _addTodo() {
    print('[DEBUG] Add Todo button pressed');
    print('[DEBUG] Title: "${_titleController.text.trim()}"');
    print('[DEBUG] Description: "${_descriptionController.text.trim()}"');

    if (_formKey.currentState!.validate()) {
      print('[DEBUG] Form validation passed');

      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();

      print('[DEBUG] Dispatching AddTodo event with title: "$title"');

      context.read<TodoBloc>().add(
        AddTodo(title: title, description: description),
      );

      print('[DEBUG] AddTodo event dispatched, closing dialog');
      Navigator.pop(context);
    } else {
      print('[DEBUG] Form validation failed');
    }
  }
}
