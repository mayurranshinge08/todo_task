import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/repositories/todo_repository.dart';
import 'package:todo_app/screens/todo_screen.dart';

import 'bloc/theme_cubit.dart';
import 'bloc/todo_bloc.dart';
import 'models/task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  // Open boxes we know we'll use
  await Hive.openBox('settingsBox');
  await Hive.openBox<Task>('tasksBox');

  final todoRepository = TodoRepository();

  runApp(MyApp(repository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => TodoBloc(repository: repository)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Todo BLoC + Hive',
            themeMode: mode,
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.teal,
              brightness: Brightness.dark,
            ),
            home: const TodoScreen(),
          );
        },
      ),
    );
  }
}
