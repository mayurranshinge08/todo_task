import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/screens/todo_screen.dart';

import 'bloc/todo_bloc.dart';
import 'bloc/todo_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo BLoC App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (context) => TodoBloc(TodoRepository())..add(LoadTodos()),
        child: TodoScreen(),
      ),
    );
  }
}
